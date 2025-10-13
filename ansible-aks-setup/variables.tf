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

