data "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}
resource "kubernetes_horizontal_pod_autoscaler" "main" {
  metadata {
    name      = "nginx-hpa"
    namespace = var.k8s_namespace
  }
  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    scale_target_ref {
      kind = "Deployment"
      name = "nginx-app"
    }
  }
}