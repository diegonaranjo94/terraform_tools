
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.60.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "370547fe-e2ab-47f8-8079-4a39ce6dc0da"
}

resource "azurerm_resource_group" "rg_resource" {
  name     = var.rg_name
  location = "East US"
}

resource "azurerm_storage_account" "storage_account" {
  name                          = var.storage_account_name
  resource_group_name           = azurerm_resource_group.rg_resource.name
  location                      = azurerm_resource_group.rg_resource.location
  account_tier                  = "Standard"
  account_replication_type      = "GRS"
  public_network_access_enabled = var.storage_account_network_access

  tags = {
    environment = "staging"
  }
}