output "nic_id" {
  value = azurerm_network_interface.nic.id
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}
