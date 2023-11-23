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

# Create the vnet
module "vnet" {
  source              = "./modules/vnet"
  name                = "vnet-spoke-openai"
  address_space       = "10.0.0.0/16"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
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

# Create the private dns zone for Keyvault
module "dns_keyvault" {
  source = "./modules/dns"
  name = "keyvault"
  resource_group_name = module.keyvault.resource_group_name
  virtual_network_id = module.vnet.virtual_network_id
}

# Create private endpoint for Keyvault
module "keyvault_private_endpoint" {
    source = "./modules/privateendpoint/"

    resource_group_name = module.keyvault.resource_group_name
    location = module.keyvault.resource_group_location
    name = "keyvault"

    subnet_id = module.vnet.pe_endpoint_subnet_id
    private_link_enabled_resource_id = module.keyvault.id
    private_dns_zone_name = module.dns_keyvault.azurerm_private_dns_zone_name
    subresource_names = ["vault"]
    azurerm_private_dns_a_record_name = "keyvault"

    depends_on = [
      module.dns_keyvault,
      module.keyvault
    ]
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

# Create the private dns zone for OpenAI
module "dns" {
  source = "./modules/dns"
  name = "openai"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_id = module.vnet.virtual_network_id
}

# Create private endpoint for OpenAI
module "openai_private_endpoint" {
    source = "./modules/privateendpoint/"

    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    name = "openai"

    subnet_id = module.vnet.pe_endpoint_subnet_id
    private_link_enabled_resource_id = module.openai.id
    private_dns_zone_name = module.dns.azurerm_private_dns_zone_name
    subresource_names = ["account"]
    azurerm_private_dns_a_record_name = "openai"

    depends_on = [
      module.dns
    ]
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

# Create the private dns zone for webapp
module "dns_webapp" {
  source = "./modules/dns"
  name = "webapp"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_id = module.vnet.virtual_network_id
}

# Create private endpoint for webapp
module "webapp_private_endpoint" {
    source = "./modules/privateendpoint/"

    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    name = "keyvault"

    subnet_id = module.vnet.pe_endpoint_subnet_id
    private_link_enabled_resource_id = module.webapp.id
    private_dns_zone_name = module.dns_webapp.azurerm_private_dns_zone_name
    subresource_names = ["sites"]
    azurerm_private_dns_a_record_name = "webapp"

    depends_on = [
      module.dns_webapp
    ]
}