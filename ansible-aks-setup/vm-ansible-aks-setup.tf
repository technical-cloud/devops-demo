variable "vm_public_ip" {}
variable "vm_username" { default = "docker" }
variable "vm_password" { default = "Docker@12345" }

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

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/docker/install_ansible.sh",
      "sudo /home/docker/install_ansible.sh"
    ]
  }
}
