
resource "azurerm_virtual_network" "vipin-vnet-local" {
  resource_group_name = azurerm_resource_group.vipin-rg-local.name
  location            = azurerm_resource_group.vipin-rg-local.location
  name                = var.vnetname
  address_space       = [var.vnetaddr[0]]
}

resource "azurerm_subnet" "vipin-subnet-local" {
  count                = length(var.subnetname)
  name                 = var.subnetname[count.index]
  resource_group_name  = azurerm_resource_group.vipin-rg-local.name
  virtual_network_name = azurerm_virtual_network.vipin-vnet-local.name
  address_prefixes     = [var.subnetaddr[count.index]]
}

resource "azurerm_public_ip" "vipin-public-ip-local" {
  count               = length(var.subnetname)
  name                = "vipin-public-ip-${count.index}"
  resource_group_name = azurerm_resource_group.vipin-rg-local.name
  location            = azurerm_resource_group.vipin-rg-local.location
  allocation_method   = "Static"
}

# Create a network interface in each subnet
resource "azurerm_network_interface" "vipin-nic-local" {
  count               = length(var.subnetname)
  name                = "${var.nicname}-${count.index}"
  resource_group_name = azurerm_resource_group.vipin-rg-local.name
  location            = azurerm_resource_group.vipin-rg-local.location
  ip_configuration {
    name                          = "ip-${var.nicname}-${count.index}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vipin-subnet-local[count.index].id
    public_ip_address_id          = azurerm_public_ip.vipin-public-ip-local[count.index].id
  }
}



