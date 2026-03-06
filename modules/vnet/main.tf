resource "azurerm_virtual_network" "itaca_network" {
  name                = "itaca-vnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "itaca_subnet" {
  name                 = "itaca-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.itaca_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "itaca_public_ip" {
  name                = "itaca-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}