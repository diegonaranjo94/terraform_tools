
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
