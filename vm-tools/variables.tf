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