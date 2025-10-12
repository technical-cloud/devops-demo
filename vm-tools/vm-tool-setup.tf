variable "vm_public_ip" {
  description = "Public IP of the created VM"
  type        = string
}

resource "null_resource" "install_devops_tools" {
  depends_on = [azurerm_linux_virtual_machine.vipin_vm_local]

  connection {
    type     = "ssh"
    host     = azurerm_linux_virtual_machine.vipin_vm_local[0].public_ip_address
    user     = "docker"
    password = "Docker@12345"
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