output "vnet_id_spoke" {
  value = azurerm_virtual_network.spoke[*].id
}

output "vnet_name_spoke" {
  value = azurerm_virtual_network.spoke[*].name
}
 
output "resource_group_name_spoke" {
  value = azurerm_resource_group.connectivity_spoke[*].name
}