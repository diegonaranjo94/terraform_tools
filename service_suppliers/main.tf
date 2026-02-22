resource "azurecaf_name" "rg_name" {
  name          = "example"
  resource_type = "azurerm_resource_group"
  prefixes      = [ "dev" ]
  suffixes      = ["y", "z"]
  random_length = 3
  clean_input   = true
}

resource "azurerm_resource_group" "rg_resource" {
  name     = azurecaf_name.rg_name.result
  location = "East US"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_resource.name
  location                 = azurerm_resource_group.rg_resource.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  public_network_access_enabled = var.storage_account_network_access

  tags = {
    environment = "staging"
  }
}