terraform {
  required_version = ">= 1.3.0"
  backend "azurerm" {
    resource_group_name  = var.tfBackendRG
    storage_account_name = var.tfBackendStorage
    container_name       = var.tfBackendContainer
    key                  = "${var.aksName}.tfstate"
  }
}

provider "azurerm" {
  features {}
}