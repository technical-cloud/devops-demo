
resource "azurerm_virtual_network" "vipin_vnet_local" {
  resource_group_name = azurerm_resource_group.vipin_rg_local.name
  location            = azurerm_resource_group.vipin_rg_local.location
  name                = var.vnetname
  address_space       = [var.vnetaddr[0]]
}

resource "azurerm_subnet" "vipin_subnet_local" {
  count                = length(var.subnetname)
  name                 = var.subnetname[count.index]
  resource_group_name  = azurerm_resource_group.vipin_rg_local.name
  virtual_network_name = azurerm_virtual_network.vipin_vnet_local.name
  address_prefixes     = [var.subnetaddr[count.index]]
}
