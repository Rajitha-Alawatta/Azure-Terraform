resource "azurerm_private_endpoint" "main" {
  name                = lower("aks_acr_${var.environment}_pe")
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = lower("aks_acr_${var.environment}_pe")
    private_connection_resource_id = var.private_connection_id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = lower("acr${var.environment}nginx")
    private_dns_zone_ids = var.private_dns_zone_id
  }
}