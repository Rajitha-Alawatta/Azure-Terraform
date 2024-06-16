terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.93.0"
    }
  }
  #backend "azurerm" {
  #  resource_group_name  = "test-resource-group"
  #  storage_account_name = "tfstatedbhawkdevtest"
  #  container_name       = "terraform-state"
  #  key                  = "dev-test-infrastructure.tfstate"
  #}
}

provider "azurerm" {
  features {}
  subscription_id = "0c2ccdca-dddf-477a-9184-418bf687c29c" # Pay-As-You-Go Subscription
}

provider "azuread" {}