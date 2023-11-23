data "azurerm_client_config" "current" {}

# RESOURCE (RESROUCE GROUP)
resource "azurerm_resource_group" "keyvault" {
  name     = lower("rg-${var.name_company_department}-${var.random_string}")
  location = var.location

  tags = {
    Environment = var.environment
    Company     = var.company
    CreatedBy   = "Terraform"
  }
}

# RESOURCE (RANDOM ID)
resource "random_id" "azurerm_name_suffix" {
  byte_length = 3
}

# RESOURCE (KEYVAULT)
resource "azurerm_key_vault" "management" {
  name                        = lower("kv-${var.name_company_department}-${var.name_prefix}")
  location                    = azurerm_resource_group.keyvault.location
  resource_group_name         = azurerm_resource_group.keyvault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "Purge",
      "Delete"
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Purge",
      "Recover",
      "Delete"
    ]

    storage_permissions = [
      "Get",
      "Set",
      "List"
    ]
  }
}