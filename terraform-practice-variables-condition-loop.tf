

resource "azurerm_resource_group" "vipin_resource_group" {
  name     = var.vipin_resource_group_name
  location = var.vipin_resource_group_location
}

resource "azurerm_storage_account" "vipin_storage_account" {
  name                     = var.vipin_storage_account_name
  resource_group_name      = var.vipin_resource_group_name
  location                 = var.vipin_resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "vipin_storage_container" {
  name                  = "tfstate"
  storage_account_name  = var.vipin_storage_account_name
  container_access_type = "private"
}

resource "azurerm_virtual_network" "vipin_virtual_network" {
  name                = var.vipin_virtual_network_name
  address_space       = [var.vipin_virtual_network_address_space[0]]
  location            = var.vipin_resource_group_location
  resource_group_name = var.vipin_resource_group_name
}

resource "azurerm_subnet" "vipin_subnet" {
  count                = var.subnet_count
  name                 = "${var.vipin_subnet_name}-${count.index + 1}"
  resource_group_name  = var.vipin_resource_group_name
  virtual_network_name = var.vipin_virtual_network_name
  address_prefixes     = ["172.25.${count.index}.0/24"]
}

resource "azurerm_public_ip" "vipin_public_ip" {
  name                = "vipin-public-ip"
  location            = var.vipin_resource_group_location
  resource_group_name = var.vipin_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vipin_nic_with_public_ip" {
  name                = "vipin-nic-public"
  location            = var.vipin_resource_group_location
  resource_group_name = var.vipin_resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vipin_subnet[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vipin_public_ip.id
  }
}

resource "azurerm_network_security_group" "vipin_nsg" {
  name                = "vipin-nsg"
  location            = var.vipin_resource_group_location
  resource_group_name = var.vipin_resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vipin_nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.vipin_nic_with_public_ip.id
  network_security_group_id = azurerm_network_security_group.vipin_nsg.id
}

resource "azurerm_linux_virtual_machine" "vipin_vm" {
  count               = var.create_vm ? 1 : 0
  name                = var.vipin_virtual_machine_name
  resource_group_name = var.vipin_resource_group_name
  location            = var.vipin_resource_group_location
  size                = "Standard_B1s"
  admin_username      = "docker"
  network_interface_ids = [
    azurerm_network_interface.vipin_nic_with_public_ip.id
  ]
  admin_password                  = "Docker@12345"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "vipin-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}


output "resource_group_name" {
  value = azurerm_resource_group.vipin_resource_group.name
}
output "virtual_network_name" {
  value = azurerm_virtual_network.vipin_virtual_network.name
}
output "subnet_names" {
  value = azurerm_subnet.vipin_subnet[*].name
}
output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.vipin_vm[*].name
}
output "public_ip_address" {
  value = azurerm_public_ip.vipin_public_ip.ip_address
}

output "storage_account_id" {
  value = azurerm_storage_account.vipin_storage_account.id
}

output "storage_account_key" {
  value     = azurerm_storage_account.vipin_storage_account.primary_access_key
  sensitive = true
}
