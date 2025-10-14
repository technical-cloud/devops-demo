resource "azurerm_network_security_group" "vipin_nsg_group_local" {
  name                = "vipin-demo-nsg-group"
  resource_group_name = azurerm_resource_group.vipin_rg_local.name
  location            = azurerm_resource_group.vipin_rg_local.location

  # --- Inbound SSH Rule ---
  security_rule {
    name                       = "Allow-SSH-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow SSH for provisioning"
  }

  # --- Dynamic inbound rules (custom app ports, etc.) ---
  dynamic "security_rule" {
    for_each = var.nsgrules
    content {
      name                       = "${security_rule.value.rulename}-inbound"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.dport
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Dynamic inbound rule"
    }
  }

  # --- Dynamic outbound rules ---
  dynamic "security_rule" {
    for_each = var.nsgrules
    content {
      name                       = "${security_rule.value.rulename}-outbound"
      priority                   = security_rule.value.priority + 1000
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.dport
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Dynamic outbound rule"
    }
  }

  # --- Default outbound internet access ---
  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow all outbound traffic"
  }
}

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "vipin_subnet_nsg_assoc_local" {
  count                     = length(var.subnetname)
  subnet_id                 = azurerm_subnet.vipin_subnet_local[count.index].id
  network_security_group_id = azurerm_network_security_group.vipin_nsg_group_local.id
}
