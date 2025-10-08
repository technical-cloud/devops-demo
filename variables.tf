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

variable "region" {
  type = string
}

variable "rgname" {
  type = string
}

variable "vnetname" {
  type = string
}

variable "vnetaddr" {
  type = list(any)
}

variable "subnetname" {
  type = list(any)
}

variable "subnetaddr" {
  type = list(any)
}

variable "nicname" {
  type = string
}

variable "nsgrules" {
  type = list(map(any))
}

variable "agent_pool" {
  type = string
}

variable org_url {
  type = string  
}

variable "ado_pat" {
  description = "Azure DevOps PAT token"
  type        = string
  sensitive   = true
}