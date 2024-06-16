data "azurerm_kubernetes_cluster" "main" {
  name                = module.azure-kubernetes-service.kubernetes_cluster_name
  resource_group_name = local.resource_group_name
  depends_on          = [module.azure-kubernetes-service]
}

data "kubernetes_service" "service_ingress" {
  metadata {
    name      = "ingress-nginx-controller-controller"
    namespace = "nginx-ingress"
  }
  depends_on = [module.nginx-ingress-controller]
}

locals {
  environment             = var.environment
  resource_group_name     = module.azure-resource-group.resource_group_name
  resource_group_location = module.azure-resource-group.resource_group_location

  # AKS Platform Components Versions
  nginx_ingress_controller_version = "4.10.0"
  cert_manager_version             = "1.14.4"
  kubernetes_dashboard_version     = "6.0.0"
  oauth2_proxy_version             = "6.2.1"
}

## Azure Infrastructure ##

module "azure-resource-group" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-resource-group"

  resource_group_name = var.resource_group_name
}

module "azure-storage-account" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-storage-account"

  storage_account_name    = var.storage_account_name
  container_name          = "terraform-state"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  environment             = local.environment
}

module "azure-network" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-network"

  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  environment             = local.environment
}

module "azure-kubernetes-service" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-kubernetes"

  min_node_count          = var.min_node_count
  max_node_count          = var.max_node_count
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  environment             = local.environment
  subnet_id               = module.azure-network.subnet_id

  depends_on = [module.azure-network]
}

module "azure-container-registry" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-container-registry"

  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  environment             = local.environment
}

module "azure-private-dns-zone" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-private-dns-zone"

  resource_group_name = local.resource_group_name
  environment         = local.environment
  vnet_id             = module.azure-network.vnet_id
}

module "azure-private-endpoint" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-private-endpoint"

  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  environment             = local.environment
  subnet_id               = module.azure-network.subnet_id
  private_connection_id   = module.azure-container-registry.acr_id
  private_dns_zone_id     = [module.azure-private-dns-zone.private_dns_zone_id]

  depends_on = [module.azure-private-dns-zone]
}

module "azure-role-assignment" {
  source = "../terraform-infrastructure/modules/azure-infrastructure/azure-role-assignment"

  k8s_principal_id = module.azure-kubernetes-service.principal_id
  k8s_scope        = module.azure-container-registry.acr_id
}

## Platform Components ##

module "nginx-ingress-controller" {
  source = "../terraform-infrastructure/modules/platform-components/nginx-ingress"

  nginx_version           = local.nginx_ingress_controller_version
  resource_group_name     = local.resource_group_name
  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [module.azure-kubernetes-service]
}

module "cert-manager" {
  source = "../terraform-infrastructure/modules/platform-components/cert-manager"

  cert_manager_version    = local.cert_manager_version
  resource_group_name     = local.resource_group_name
  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [module.azure-kubernetes-service]
}

module "kubernetes-dashboard" {
  source = "../terraform-infrastructure/modules/platform-components/kubernetes-dashboard"

  kubernetes_dashboard_version = local.kubernetes_dashboard_version

  depends_on = [module.azure-kubernetes-service]
}

resource "kubectl_manifest" "k8s_cluster_issuer" {
  yaml_body = file("${path.module}/kubernetes-resources/k8s-clusterissuer.yaml")

  depends_on = [module.cert-manager]
}

resource "kubectl_manifest" "k8s_cluster_role_binding" {
  yaml_body = file("${path.module}/kubernetes-resources/k8s-cluster-role-binding.yaml")

  depends_on = [module.kubernetes-dashboard]
}

## Kubernetes Resources ##

module "kubernetes-clusterip-service" {
  source = "../terraform-infrastructure/modules/kubernetes-resources/k8s-service"

  resource_group_name     = local.resource_group_name
  k8s_namespace           = module.kubernetes-nginx-app-namespace.k8s_namespace
  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [module.azure-kubernetes-service]
}

module "kubernetes-nginx-app-namespace" {
  source = "../terraform-infrastructure/modules/kubernetes-resources/k8s-nginx-app-namespace"

  k8s_namespace           = var.k8s_namespace
  resource_group_name     = local.resource_group_name
  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [module.azure-kubernetes-service]
}

module "kubernetes-horizontal-pod-autoscaler" {
  source = "../terraform-infrastructure/modules/kubernetes-resources/k8s-horizontal-pod-autoscaler"

  min_replicas            = 2
  max_replicas            = 3
  resource_group_name     = local.resource_group_name
  k8s_namespace           = module.kubernetes-nginx-app-namespace.k8s_namespace
  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [module.azure-kubernetes-service]
}

module "kubernetes-persistent-volume-claim" {
  source = "../terraform-infrastructure/modules/kubernetes-resources/k8s-persistent-volume-claim"

  resource_group_name     = local.resource_group_name
  k8s_namespace           = module.kubernetes-nginx-app-namespace.k8s_namespace
  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [module.azure-kubernetes-service]
}

module "kubernetes-nginx-app-nginx-ingress" {
  source = "../terraform-infrastructure/modules/kubernetes-resources/k8s-nginx-app-ingress"

  ingress_url             = var.nginx_app_url
  resource_group_name     = local.resource_group_name
  k8s_namespace           = module.kubernetes-nginx-app-namespace.k8s_namespace
  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [module.azure-kubernetes-service]
}

module "kubernetes-k8s-dashboard-nginx-ingress" {
  source = "../terraform-infrastructure/modules/kubernetes-resources/k8s-dashboard-ingress"

  k8s_dashboard_ingress_url = var.k8s_dashboard_url
  k8s_dashboard_namespace   = var.k8s_dashboard_namespace
  resource_group_name       = local.resource_group_name
  kubernetes_cluster_name   = module.azure-kubernetes-service.kubernetes_cluster_name

  depends_on = [
    module.azure-kubernetes-service,
    module.kubernetes-dashboard
  ]
}

module "kubernetes-deployment" {
  source = "../terraform-infrastructure/modules/kubernetes-resources/k8s-deployment"

  nginx_container_cpu    = var.nginx_container_cpu
  nginx_container_memory = var.nginx_container_memory

  nginx_image           = var.nginx_image
  nginx_container_count = var.nginx_pod_count
  resource_group_name   = local.resource_group_name
  k8s_namespace         = module.kubernetes-nginx-app-namespace.k8s_namespace

  kubernetes_cluster_name = module.azure-kubernetes-service.kubernetes_cluster_name
  depends_on = [
    module.azure-kubernetes-service,
    module.azure-role-assignment,
  ]
}