terraform {
  backend "azurerm" {
    storage_account_name = "remotestateterraform"
    container_name       = "states"
    key                  = "state.tfstate"
  }
}