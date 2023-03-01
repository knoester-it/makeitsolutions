# RESOURCES (RESOURCE GROUP)
resource "azurerm_resource_group" "connectivity_spoke" {
  count     = length(var.name_spoke)
  name      = "rg-connectivity-spoke-${var.name_spoke[count.index]}${var.random_integer}"
  location = var.location

  tags = {
    Environment = var.environment
    Company     = var.company
  }
}

# RESOURCES (Spoke VNET)
resource "azurerm_virtual_network" "spoke" {
  count               = length(var.name_spoke)
  name                = "vnet-spoke-${var.name_spoke[count.index]}"
  address_space       = [element(var.network_address_space_spoke, count.index)]
  location            = azurerm_resource_group.connectivity_spoke[count.index].location
  resource_group_name = azurerm_resource_group.connectivity_spoke[count.index].name
}

# RESOURCES (Spoke Endpoint Subnet)
resource "azurerm_subnet" "spoke_endpoint_subnet" {
  count                = length(var.name_spoke)
  name                 = "${var.spoke_endpoint_subnet_name}-${var.name_spoke[count.index]}"
  resource_group_name  = azurerm_resource_group.connectivity_spoke[count.index].name
  virtual_network_name = azurerm_virtual_network.spoke[count.index].name
  address_prefixes     = [cidrsubnet("${var.network_address_space_spoke[count.index]}",2,1)]
}

# RESOURCES (Spoke Private Link Subnet)
resource "azurerm_subnet" "spoke_privatelinkendpoints_subnet" {
  count                = length(var.name_spoke)
  name                 = "${var.spoke_privatelinkendpoints_subnet_name}-${var.name_spoke[count.index]}"
  resource_group_name  = azurerm_resource_group.connectivity_spoke[count.index].name
  virtual_network_name = azurerm_virtual_network.spoke[count.index].name
  address_prefixes     = [cidrsubnet("${var.network_address_space_spoke[count.index]}",4,1)]

  private_endpoint_network_policies_enabled = true
}

# RESOURCES (NSG for Spoke Private Link Subnet)
resource "azurerm_network_security_group" "nsg_spoke_privatelinkendpoints" {
  count                = length(var.name_spoke)
  name                 = "nsg-${azurerm_subnet.spoke_privatelinkendpoints_subnet[count.index].name}"
  location             = azurerm_resource_group.connectivity_spoke[count.index].location
  resource_group_name  = azurerm_resource_group.connectivity_spoke[count.index].name

  security_rule {
    name                       = "AllowAll443InFromVnet"
    priority                   = 100 
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 1000 
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
} 

resource "azurerm_subnet_network_security_group_association" "association_privatelinkendpoints_subnet" {
  count                     = length(var.name_spoke)
  subnet_id                 = azurerm_subnet.spoke_privatelinkendpoints_subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg_spoke_privatelinkendpoints[count.index].id
}

# RESOURCES (NSG for Endpoint Subnet)

resource "azurerm_network_security_group" "nsg_spoke_endpoint_subnet" {
  count                = length(var.name_spoke)
  name                 = "nsg-${azurerm_subnet.spoke_endpoint_subnet[count.index].name}"
  location             = azurerm_resource_group.connectivity_spoke[count.index].location
  resource_group_name  = azurerm_resource_group.connectivity_spoke[count.index].name

  security_rule {
    name                       = "AllowAll443InFromVnet"
    priority                   = 100 
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

security_rule {
    name                       = "AllowAll3389InFromVnet"
    priority                   = 101 
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAll22InFromVnet"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 1000 
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 

} 

# RESOURCES (NSG Association)
resource "azurerm_subnet_network_security_group_association" "association_endpoint_subnet" {
  count                     = length(var.name_spoke)
  subnet_id                 = azurerm_subnet.spoke_endpoint_subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg_spoke_endpoint_subnet[count.index].id
}