output "azurerm_private_dns_zone" {
    value = azurerm_private_dns_zone.openai.id
}

output "azurerm_private_dns_zone_name" {
    value = azurerm_private_dns_zone.openai.name
}