data "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}
resource "kubernetes_namespace" "main" {
  metadata {
    name = var.k8s_namespace
  }
}