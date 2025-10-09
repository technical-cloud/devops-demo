resource "azurerm_resource_group" "vipin_rg_local" {
  name     = var.rgname
  location = var.region
}