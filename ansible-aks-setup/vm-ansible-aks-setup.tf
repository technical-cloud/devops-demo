variable "vm_public_ip" {
  description = "Public IP of the VM to connect via SSH"
  type        = string
}

variable "vm_username" {
  description = "SSH username for the VM"
  type        = string
  default     = "docker"
}

variable "vm_password" {
  description = "SSH password for the VM"
  type        = string
  default     = "Docker@12345"
}

resource "null_resource" "ansible_install" {
  connection {
    type     = "ssh"
    host     = var.vm_public_ip
    user     = var.vm_username
    password = var.vm_password
  }

  provisioner "file" {
    source      = "install_ansible.sh"
    destination = "/home/docker/install_ansible.sh"
  }

  provisioner "file" {
    source      = "aks_playbook.yml"
    destination = "/home/docker/aks_playbook.yml"
  }

  provisioner "file" {
    source      = "azure_env.sh"
    destination = "/home/docker/azure_env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/docker/install_ansible.sh",
      "sudo /home/docker/install_ansible.sh"
    ]
  }
}
