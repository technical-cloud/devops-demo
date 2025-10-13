resource "azurerm_public_ip" "vipin_public_ip_local" {
  count               = length(var.subnetname)
  name                = "vipin-public-ip-${count.index}"
  location            = azurerm_resource_group.vipin_rg_local.location
  resource_group_name = azurerm_resource_group.vipin_rg_local.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vipin_nic_local" {
  count               = length(var.subnetname)
  name                = "vipin-nic-${count.index}"
  location            = azurerm_resource_group.vipin_rg_local.location
  resource_group_name = azurerm_resource_group.vipin_rg_local.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vipin_subnet_local[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vipin_public_ip_local[count.index].id
  }
}

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
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-Gen2"  
  }

  # Stage 1 cloudinit only prepares VM
  custom_data = base64encode(file("${path.module}/cloudinit.sh"))
}

output "public_ip_addresses" {
  value = azurerm_public_ip.vipin_public_ip_local[*].ip_address
}