output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.main.id
}

output "synapse_workspace_identity" {
  value = azurerm_synapse_workspace.main.identity[0].principal_id
}

output "synapse_spark_pool_id" {
  value = azurerm_synapse_spark_pool.main.id
}
