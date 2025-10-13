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
    "echo '=== Loading Azure credentials ==='",
    "source /home/docker/azure_env.sh",
    "echo '=== Logging into Azure ==='",
    "az login --service-principal -u \"$AZ_CLIENT_ID\" -p \"$AZ_CLIENT_SECRET\" --tenant \"$AZ_TENANT_ID\""
  ]
}

  }

