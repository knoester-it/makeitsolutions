output "virtual_network_id" {
    value = azurerm_virtual_network.openai.id
}

output "pe_endpoint_subnet_id" {
    value = azurerm_subnet.endpoint_subnet.id
}