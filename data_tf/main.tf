data "azurerm_resource_group" "imported_rg" {
  name = "remotestate"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "remotestateterraformtwo"
  resource_group_name      = data.azurerm_resource_group.imported_rg.name
  location                 = data.azurerm_resource_group.imported_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}