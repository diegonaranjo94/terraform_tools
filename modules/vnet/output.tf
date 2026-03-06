output "subnet_id" {
  value = azurerm_subnet.itaca_subnet.id
}

output "public_ip_id" {
  value = azurerm_public_ip.itaca_public_ip.id
}