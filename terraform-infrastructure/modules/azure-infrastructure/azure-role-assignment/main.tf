resource "azurerm_role_assignment" "kubernetes_cluster_pull_access" {
  principal_id                     = var.k8s_principal_id
  role_definition_name             = "AcrPull"
  scope                            = var.k8s_scope
  skip_service_principal_aad_check = true
}