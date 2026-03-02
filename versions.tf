terraform {

  required_version = "~> 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.1"

    }
  }
}

provider "azurerm" {
  storage_use_azuread = true
  features {}
}
