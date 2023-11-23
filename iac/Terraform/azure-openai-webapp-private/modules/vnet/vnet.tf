resource "azurerm_virtual_network" "openai" {
  name                = var.name
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "public_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.openai.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "endpoint_subnet" {
  name                 = "endpoint_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.openai.name
  address_prefixes     = ["10.0.2.0/24"]

  private_endpoint_network_policies_enabled = true
}