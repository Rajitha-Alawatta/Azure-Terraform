resource "azurerm_databricks_workspace" "main" {
  name                = lower("dbw-${var.environment}")
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = var.sku

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.virtual_network_id
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_association_id
    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_association_id
  }

  tags = {
    Environment = var.environment
  }
}
