# RESOURCES (Subnet)
resource "azurerm_subnet" "subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg_name_hub
  virtual_network_name = var.vnet_name_hub
  address_prefixes     = var.network_address_space_firewall
}

# RESOURCES (FW Public IP)
resource "azurerm_public_ip" "pip" {
    lifecycle {
    create_before_destroy = true
 }
  name                = "azfirewallpip"
  location            = var.location
  resource_group_name = var.rg_name_hub
  allocation_method   = "Static"
  sku                 = "Standard"
}

# RESOURCES (FIREWALL)
resource "azurerm_firewall" "fw" {
  name                = "azfirewall"
  location            = var.location
  resource_group_name = var.rg_name_hub
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

# RESOURCES (FIREWALL_Application Collection rules)
resource "azurerm_firewall_application_rule_collection" "app-rc" {
  name                = "apptestcollection"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.rg_name_hub
  priority            = 100
  action              = "Allow"

  rule {
    name = "examplerule"

    source_addresses = var.network_address_space_spoke

    target_fqdns = [
      "*.google.com",
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

# RESOURCES (FIREWALL_Network Collection rules)
resource "azurerm_firewall_network_rule_collection" "net-rc" {
  name                = "netcollection"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.rg_name_hub
  priority            = 100
  action              = "Allow"

  rule {
    name = "dnsrule"

    source_addresses = var.network_address_space_spoke

    destination_ports = [
      "53",
    ]

    destination_addresses = [
      "8.8.8.8",
      "8.8.4.4",
    ]

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}

# RESOURCES (Route Tables)
resource "azurerm_route_table" "spokes" {
  count                         = length(var.name_spoke)
  name                          = "route-table-${var.name_spoke[count.index]}"
  location                      = var.location
  resource_group_name           = var.rg_name_hub
  disable_bgp_route_propagation = false

  route {
    name                    = "route-to-firewall"
    address_prefix          = "${var.network_address_space_spoke[count.index]}"
    next_hop_type           = "VirtualAppliance"
    next_hop_in_ip_address  = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }

  tags = {
    environment = var.environment
  }
}