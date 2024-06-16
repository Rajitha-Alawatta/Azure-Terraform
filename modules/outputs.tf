output "loadbalanbcer_ip" {
  value = data.kubernetes_service.service_ingress.status[0].load_balancer[0].ingress[0].ip
}

output "nginx_app_url" {
  value = module.kubernetes-nginx-app-nginx-ingress.nginx_url
}

output "kubernetes_dashboard_url" {
  value = module.kubernetes-k8s-dashboard-nginx-ingress.k8s_dashboard_url
}

output "resource_group" {
  value = local.resource_group_name
}

output "aks_cluster_name" {
  value = module.azure-kubernetes-service.kubernetes_cluster_name
}