data "azurerm_client_config" "current" {
}

resource "random_string" "prefix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_resource_group" "rg" {
  name     = lower("rg-${var.company}-${var.name_prefix}-${var.openai_name}-${random_string.prefix.result}")
  location = var.location
  tags     = var.tags
}

# Create the keyvault
module "keyvault" {
  source                                    = "./modules/keyvault"
  random_string                             = "${random_string.prefix.result}"
  name_company_department                   = "${var.company}-mgmt"
  location                                  = var.location
  company                                   = var.company
  environment                               = var.environment
  name_prefix                               = var.name_prefix
}

# Create the openai instance
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

# Create the webapp for ChatGPT
module "webapp" {
  source                                   = "./modules/webapp"
  name                                     = lower(var.name_prefix == null ? "${random_string.prefix.result}${var.openai_name}-${random_string.prefix.result}" : "${var.name_prefix}-${var.openai_name}-${random_string.prefix.result}")
  location                                 = var.location
  resource_group_name                      = azurerm_resource_group.rg.name
  sku_name                                 = var.sku_name
  openai_name                              = module.openai.name
  key_vault_name                           = module.keyvault.name
  key_vault_resource_group                 = module.keyvault.resource_group_name
  openai_primary_access_key                = module.openai.primary_access_key
  tags                                     = var.tags
    
    depends_on = [module.openai]
    # Add multiple depends_on if you have more modules : depends_on = [module.openai, module.azuread_application]
}