resource "azurerm_virtual_network" "main" {
  name                = lower("aks-${var.environment}-vnet")
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["172.16.0.0/16"]

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "main" {
  name                 = lower("aks-${var.environment}-subnet")
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.0/24"]
}