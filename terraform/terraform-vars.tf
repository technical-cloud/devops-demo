# terraform/variable.tf
# All default values removed

variable "aksName" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "location" {
  type        = string
  description = "Azure region for AKS"
}

variable "resourceGroup" {
  type        = string
  description = "Resource group for AKS"
}

variable "aksNodeCount" {
  type        = number
  description = "Number of nodes in AKS cluster"
}

variable "aksNodeVMSize" {
  type        = string
  description = "VM size for AKS nodes"
}

variable "tfBackendRG" {
  type        = string
  description = "Terraform backend resource group"
}

variable "tfBackendStorage" {
  type        = string
  description = "Terraform backend storage account"
}

variable "tfBackendContainer" {
  type        = string
  description = "Terraform backend container name"
}