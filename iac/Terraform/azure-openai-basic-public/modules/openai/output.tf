output "id" {
  value = azurerm_cognitive_account.openai.id
  description = "Specifies the resource id"
}

output "location" {
  value = azurerm_cognitive_account.openai.location
  description = "Specifies the location"
}

output "name" {
  value = azurerm_cognitive_account.openai.name
  description = "Specifies the name"
}

output "resource_group_name" {
  value = azurerm_cognitive_account.openai.resource_group_name
  description = "Specifies the name of the resource group"
}

output "endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
  description = "Specifies the endpoint of the Azure OpenAI Service."
}

output "primary_access_key" {
  value = azurerm_cognitive_account.openai.primary_access_key #endpoint for endpoint url
  description = "Specifies the primary access key of the Azure OpenAI Service."
}

output "secondary_access_key" {
  value = azurerm_cognitive_account.openai.secondary_access_key #endpoint for endpoint url
  description = "Specifies the secondary access key of the Azure OpenAI Service."
}