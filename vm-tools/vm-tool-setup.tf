custom_data = base64encode(templatefile("${path.module}/cloudinit.sh", {
  org_url    = var.org_url
  ado_pat    = var.ado_pat
  agent_pool = var.agent_pool
  agent_name = var.agent_name
))

output "public_ip_addresses" {
  value = azurerm_public_ip.vipin_public_ip_local[*].ip_address
}