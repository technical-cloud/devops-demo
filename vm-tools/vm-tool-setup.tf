variable "vm_public_ip" {
  description = "Public IP of the VM created in Stage 1"
  type        = string
}

variable "agent_user" {
  description = "VM username"
  type        = string
  default     = "docker"
}

variable "agent_pass" {
  description = "VM password"
  type        = string
  default     = "Docker@12345"
}

resource "null_resource" "install_devops_tools" {
  connection {
    type     = "ssh"
    host     = var.vm_public_ip
    user     = var.agent_user
    password = var.agent_pass
  }

  provisioner "file" {
    source      = "${path.module}/cloudinit.sh"
    destination = "/tmp/cloudinit.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/cloudinit.sh",
      "sudo /tmp/cloudinit.sh"
    ]
  }
}
