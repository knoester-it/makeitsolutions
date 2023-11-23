output "name" {
  value = azurerm_key_vault.management.name
  description = "Specifies the name of the key vault"
}

output "resource_group_name" {
  value = azurerm_resource_group.keyvault.name
  description = "Specifies the name of the resource group that contains the key vault"
}

output "resource_group_location" {
  value = azurerm_resource_group.keyvault.location
  description = "Specifies the location of the resource group that contains the key vault"
}

output "id" {
  value = azurerm_key_vault.management.id
  description = "Specifies the resource id of the log analytics workspace"
}