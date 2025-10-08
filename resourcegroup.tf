resource "azurerm_resource_group" "vipin-rg-local" {
  name     = var.rgname
  location = var.region
}