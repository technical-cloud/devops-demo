resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aksName
  location            = var.location
  resource_group_name = var.resourceGroup
  dns_prefix          = var.aksName

  default_node_pool {
    name       = "default"
    node_count = var.aksNodeCount
    vm_size    = var.aksNodeVMSize
  }

  identity {
    type = "SystemAssigned"
  }
}