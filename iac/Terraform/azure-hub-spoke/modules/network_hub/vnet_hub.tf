# RESOURCES (RESOURCE GROUP)
resource "azurerm_resource_group" "connectivity_shared_hub" {
  name     = var.rg_name_hub
  location = var.location

  tags = {
    Environment = var.environment
    Company     = var.company
  }
}

# RESOURCES (HUB-Shared VNET)
resource "azurerm_virtual_network" "vnet_regional_hub_shared" {
  name                = "vnet-hub-${var.name_hub}"
  address_space       = [var.network_address_space_hub]
  location            = azurerm_resource_group.connectivity_shared_hub.location
  resource_group_name = azurerm_resource_group.connectivity_shared_hub.name
  
  tags = {
    Environment = var.environment
  }
}

# RESOURCES (PEERING HUB2SPOKE)
resource "azurerm_virtual_network_peering" "hub2spoke" {
  count               = length(var.name_spoke)
  name                = "peer-hub2spoke-${var.name_spoke[count.index]}"
  resource_group_name       = azurerm_resource_group.connectivity_shared_hub.name
  virtual_network_name      = azurerm_virtual_network.vnet_regional_hub_shared.name
  remote_virtual_network_id = element(var.remote_virtual_network_id, count.index)
}

# RESOURCES (PEERING SPOKE2HUB)
resource "azurerm_virtual_network_peering" "spoke_2regional_hub" {
  count                     = length(var.name_spoke)
  name                      = "peer-spoke-${var.name_spoke[count.index]}-2regionalhub"
  resource_group_name       = element(var.resource_group_name_spoke, count.index)
  virtual_network_name      = element(var.vnet_name_spoke, count.index)
  remote_virtual_network_id = azurerm_virtual_network.vnet_regional_hub_shared.id
}