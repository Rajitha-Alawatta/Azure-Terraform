resource "azurerm_eventhub_namespace" "main" {
  name                = lower("evhns-${var.environment}")
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = var.capacity

  auto_inflate_enabled     = true
  maximum_throughput_units = var.max_throughput_units

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_eventhub" "main" {
  name                = "evh-${var.environment}"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_consumer_group" "main" {
  name                = "evh-cg-${var.environment}"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.main.name
  resource_group_name = var.resource_group_name
}
