data "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}
resource "kubernetes_persistent_volume_claim_v1" "main" {
  metadata {
    name      = "example-nginx-pvc"
    namespace = var.k8s_namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = "azurefile"
  }
}