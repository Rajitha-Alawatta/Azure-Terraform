resource "azurerm_kubernetes_cluster" "main" {
  name                = lower("aks-${var.environment}")
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "nginx-${var.environment}"

  network_profile {
    network_plugin = "azure"
  }

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  name                  = "application"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_DS2_v2"
  zones                 = [1, 2, 3]
  enable_auto_scaling   = true
  max_count             = var.max_node_count
  min_count             = var.min_node_count
  vnet_subnet_id        = var.subnet_id

  tags = {
    Environment = var.environment
  }
}