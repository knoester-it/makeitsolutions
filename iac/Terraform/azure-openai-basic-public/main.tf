resource "random_string" "prefix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_resource_group" "rg" {
  name     = lower("rg-${var.name_prefix}-${var.openai_name}-${random_string.prefix.result}")
  location = var.location
  tags     = var.tags
}

module "openai" {
  source                                   = "./modules/openai"
  name                                     = lower(var.name_prefix == null ? "${random_string.prefix.result}${var.openai_name}-${random_string.prefix.result}" : "${var.name_prefix}-${var.openai_name}-${random_string.prefix.result}")
  location                                 = var.location
  resource_group_name                      = azurerm_resource_group.rg.name
  sku_name                                 = var.openai_sku_name
  tags                                     = var.tags
  deployments                              = var.openai_deployments
  custom_subdomain_name                    = var.openai_custom_subdomain_name == "" || var.openai_custom_subdomain_name == null ? var.name_prefix == null ? lower("${random_string.prefix.result}${var.openai_name}") : lower("${var.name_prefix}-${var.openai_name}-${random_string.prefix.result}") : lower(var.openai_custom_subdomain_name)
  public_network_access_enabled            = var.openai_public_network_access_enabled
}