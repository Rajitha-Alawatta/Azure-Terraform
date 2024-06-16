terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.93.0"
    }
  }
  #backend "azurerm" {
  #  resource_group_name  = "test-resource-group"
  #  storage_account_name = "tfstatenginxdevtest"
  #  container_name       = "terraform-state"
  #  key                  = "dev-test-infrastructure.tfstate"
  #}
}

provider "azurerm" {
  features {}
  subscription_id = "" # Your Azure subscription
}

provider "azuread" {}