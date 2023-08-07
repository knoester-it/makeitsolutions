terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.58"
    }
  }
}

provider "azurerm" {
  features {}
}
