resource "azurerm_container_registry" "main" {
  name                          = lower("acr${var.environment}example")
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  admin_enabled                 = true
  sku                           = "Premium"
  public_network_access_enabled = true
}