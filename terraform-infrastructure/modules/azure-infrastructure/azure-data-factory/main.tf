resource "azurerm_data_factory" "main" {
  name                = lower("adf-${var.environment}")
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "main" {
  name                = "linked-adls-${var.environment}"
  data_factory_id     = azurerm_data_factory.main.id
  url                 = var.adls_url
  use_managed_identity = true
}

resource "azurerm_data_factory_pipeline" "main" {
  name            = "pipeline-${var.environment}"
  data_factory_id = azurerm_data_factory.main.id
}
