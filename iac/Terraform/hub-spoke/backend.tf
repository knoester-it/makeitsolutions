terraform {
  backend "azurerm" {
    resource_group_name  = "<YOUR RESOURCE GROUP>"
    storage_account_name = "<YOUR STORAGE ACCOUNT>"
    container_name       = "<YOUR CONTAINER>"
    key                  = "<YOUR TFSTATE FILE>"
  }
}