
# GENERATE (RANDOM INPUT)
resource "random_integer" "number" {
  min = 100
  max = 299
}

resource "random_id" "pwd" {
  byte_length = 4
}

# MODULES
module "network_hub" {
  source                                    = "./modules/network_hub"
  rg_name_hub                               = "rg-connectivity-shared-${var.location}-${random_integer.number.result}"
  name_hub                                  = "${var.name_hub}-${random_integer.number.result}"
  name_spoke                                = module.network_spoke.vnet_name_spoke
  location                                  = var.location
  network_address_space_hub                 = var.network_address_space_hub
  company                                   = var.company
  environment                               = var.environment
  remote_virtual_network_id                 = module.network_spoke.vnet_id_spoke
  resource_group_name_spoke                 = module.network_spoke.resource_group_name_spoke
  vnet_name_spoke                           = module.network_spoke.vnet_name_spoke

    depends_on = [module.network_spoke]  
}

module "network_spoke" {
  source                                    = "./modules/network_spoke"
  random_integer                            = "-${random_integer.number.result}"
  name_spoke                                = var.name_spoke
  location                                  = var.location
  network_address_space_spoke               = var.network_address_space_spoke
  spoke_endpoint_subnet_name                = var.spoke_endpoint_subnet_name
  spoke_privatelinkendpoints_subnet_name    = var.spoke_privatelinkendpoints_subnet_name
  company                                   = var.company
  environment                               = var.environment
}

module "keyvault" {
  source                                    = "./modules/keyvault"
  random_integer                            = random_integer.number.result
  name_company_department                   = "${var.company}-mgmt"
  location                                  = var.location
  company                                   = var.company
  environment                               = var.environment
}

module "azfirewall" {
  source                                    = "./modules/azfirewall"
  rg_name_hub                               = module.network_hub.resource_group_shared_name
  vnet_name_hub                             = module.network_hub.vnet_name_hub
  name_spoke                                = var.name_spoke
  location                                  = var.location
  company                                   = var.company
  environment                               = var.environment
  network_address_space_spoke               = var.network_address_space_spoke
  network_address_space_firewall            = var.network_address_space_firewall

    depends_on = [module.network_hub]  
}

