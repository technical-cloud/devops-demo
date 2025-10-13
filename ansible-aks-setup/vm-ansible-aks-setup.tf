resource "null_resource" "ansible_install" {
  connection {
    type     = "ssh"
    host     = var.vm_public_ip
    user     = var.vm_username
    password = var.vm_password
    timeout     = "5m"
    agent    = false
  }

  # Copy necessary scripts to Ubuntu VM
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

  # Install Ansible & Azure CLI, then run playbook
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting 30s for VM to finish booting...'; sleep 30",
      "chmod +x /home/docker/install_ansible.sh",
      "bash /home/docker/install_ansible.sh"
    ]

    environment = {
      AZ_SUBSCRIPTION_ID = var.subscription_id
      AZ_CLIENT_ID       = var.client_id
      AZ_CLIENT_SECRET   = var.client_secret
      AZ_TENANT_ID       = var.tenant_id
    }
  }
}
