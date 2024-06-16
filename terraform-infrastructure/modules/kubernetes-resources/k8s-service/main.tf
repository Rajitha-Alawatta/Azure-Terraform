data "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}
resource "kubernetes_service_v1" "main" {
  metadata {
    name      = "nginx"
    namespace = var.k8s_namespace
  }
  spec {
    selector = {
      app = "sample-nginx-app"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
