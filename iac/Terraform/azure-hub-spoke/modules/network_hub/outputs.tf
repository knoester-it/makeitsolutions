output "vnet_id_hub" {
  value = azurerm_virtual_network.vnet_regional_hub_shared.id
}

output "vnet_name_hub" {
  value = azurerm_virtual_network.vnet_regional_hub_shared.name
}

output "resource_group_shared_name" {
  value = azurerm_resource_group.connectivity_shared_hub.name
}

output "resource_group_shared_id" {
  value = azurerm_resource_group.connectivity_shared_hub.id
}