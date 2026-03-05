resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "itaca_network" {
  name                = "itaca-vnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "itaca_subnet" {
  name                 = "itaca-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.itaca_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "itaca_public_ip" {
  name                = "itaca-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "itaca_nsg" {
  name                = "itaca-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "my_terraform_nic" {
    name = "itaca-nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "itaca_nic_config"
        subnet_id = azurerm_subnet.itaca_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.itaca_public_ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "nic_association" {
    network_interface_id = azurerm_network_interface.my_terraform_nic.id
    network_security_group_id = azurerm_network_security_group.itaca_nsg.id
}

resource "azurerm_windows_virtual_machine" "itaca_vm" {
    name = "itaca-vm"
    admin_username = var.vm_username
    admin_password = var.vm_password
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
    size = "Standard_B2s"

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2022-Datacenter"
        version = "latest"
    }
}