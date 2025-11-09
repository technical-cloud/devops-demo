terraform {
  required_version = ">= 1.3.0"
  backend "azurerm" {
    resource_group_name  = "vipin-tf-rg"
    storage_account_name = "vipintfstorage"
    container_name       = "tfstate"
    key                  = "aks.tfstate"
  }
}

provider "azurerm" {
  features {}
}