resource "azurerm_storage_account" "synapse" {
  name                     = lower("synapsesa${var.environment}")
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "main" {
  name               = "synapse-fs"
  storage_account_id = azurerm_storage_account.synapse.id
}

resource "azurerm_synapse_workspace" "main" {
  name                                 = lower("synapse-${var.environment}")
  resource_group_name                  = var.resource_group_name
  location                             = var.resource_group_location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.main.id
  sql_administrator_login              = var.sql_admin_username
  sql_administrator_login_password     = var.sql_admin_password

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_synapse_spark_pool" "main" {
  name                 = "sparkpool"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  node_size_family     = "MemoryOptimized"
  node_size            = var.spark_node_size

  auto_scale {
    max_node_count = var.max_node_count
    min_node_count = var.min_node_count
  }

  auto_pause {
    delay_in_minutes = 15
  }

  tags = {
    Environment = var.environment
  }
}
