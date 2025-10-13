# --------------------------------------------------------------------
# variables.tf — Define all variables once
# --------------------------------------------------------------------
var "subscription_id" {
description = "Subscription ID"
type = string
}

var "tenant_id" {
description = "Tenant ID"
type  = string
}

var "client_id" {
description = "Client ID" 
type  = string
}

var "client_secret" {
description = "Client Secret"
type  = string
}

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

