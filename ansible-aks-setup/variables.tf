variable "subscription_id" {
  description = "The Subscription ID for the Azure account."
  type        = string
}

variable "client_id" {
  description = "The Client ID (Application ID) for the Azure account."
  type        = string
}

variable "tenant_id" {
  description = "The Tenant ID for the Azure account."
  type        = string
}

variable "client_secret" {
  description = "The Client Secret (Password) for the Azure account."
  type        = string
  sensitive   = true
}


variable "vm_public_ip" {
  description = "Public IP of the VM to connect via SSH"
  type        = string
}

variable "vm_username" {
  description = "Username to SSH into VM"
  type        = string
  default     = "docker"
}

variable "vm_password" {
  description = "Password to SSH into VM"
  type        = string
  default     = "Docker@12345"
}
