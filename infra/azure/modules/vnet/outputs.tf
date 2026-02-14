output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "vm_subnet_id" {
  value = azurerm_subnet.vm.id
}

output "nsg_id" {
  value = azurerm_network_security_group.main.id
}
