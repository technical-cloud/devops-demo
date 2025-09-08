
variable "subscription_id_value" {
  description = "The Azure Subscription ID"
  type        = string
  default     = "b54b4eeb-e9a6-4f46-b1c1-6f4691cb9b72"
}

variable "vipin_resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vipin_storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "vipin_resource_group_location" {
  description = "The Azure location for the resource group"
  type        = string
  default     = "East US"
}

variable "vipin_virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vipin_virtual_network_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "vipin_subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
}

variable "vipin_virtual_machine_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "create_vm" {
  description = "Flag to create VM"
  type        = bool
}