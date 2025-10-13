# --------------------------------------------------------------------
# variables.tf — Define all variables once
# --------------------------------------------------------------------

variable "vm_public_ip" {
  description = "Public IP of the Ubuntu VM"
  type        = string
}

variable "vm_username" {
  description = "Username for Ubuntu VM"
  type        = string
}

variable "vm_password" {
  description = "Password for Ubuntu VM"
  type        = string
}

variable "aks_resource_group" {
  description = "Azure Resource Group for AKS"
  type        = string
}

variable "aks_cluster_name" {
  description = "AKS Cluster Name"
  type        = string
}

variable "aks_location" {
  description = "Azure Region for AKS"
  type        = string
  default     = "eastus2"
}

variable "aks_node_count" {
  description = "Number of nodes in AKS cluster"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}
