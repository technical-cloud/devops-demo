resource "azurerm_public_ip" "vipin_public_ip_local" {
  count               = length(var.subnetname)
  name                = "vipin-public-ip-${count.index}"
  location            = azurerm_resource_group.vipin_rg_local.location
  resource_group_name = azurerm_resource_group.vipin_rg_local.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface
resource "azurerm_network_interface" "vipin_nic_local" {
  count               = length(var.subnetname)
  name                = "vipin-nic-${count.index}"
  location            = azurerm_resource_group.vipin_rg_local.location
  resource_group_name = azurerm_resource_group.vipin_rg_local.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnetname[count.index]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vipin_public_ip_local[count.index].id
  }
}

# Linux VM with Cloud-init
resource "azurerm_linux_virtual_machine" "vipin_vm_local" {
  count                           = length(var.subnetname)
  name                            = "vipin-vm-${count.index}"
  location                        = azurerm_resource_group.vipin_rg_local.location
  resource_group_name             = azurerm_resource_group.vipin_rg_local.name
  size                            = "Standard_B1s"
  admin_username                  = "docker"
  admin_password                  = "Docker@12345"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vipin_nic_local[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloudinit.sh", {
  org_url    = var.org_url
  ado_pat    = var.ado_pat
  agent_pool = var.agent_pool
}))

}

output "public_ip_addresses" {
  value = azurerm_public_ip.vipin_public_ip_local[*].ip_address
}
