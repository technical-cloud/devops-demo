# terraform/variable.tf

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

variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "azure_client_id" {
  type        = string
  description = "Azure Client (App) ID"
}

variable "azure_client_secret" {
  type        = string
  sensitive   = true
  description = "Azure Client Secret for Service Principal"
}
