output "eventhub_namespace_id" {
  value = azurerm_eventhub_namespace.main.id
}

output "eventhub_id" {
  value = azurerm_eventhub.main.id
}

output "eventhub_name" {
  value = azurerm_eventhub.main.name
}
