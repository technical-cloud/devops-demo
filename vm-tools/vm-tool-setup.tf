variable "vm_public_ip" {
  description = "Public IP of the created VM"
  type        = string
}

resource "null_resource" "install_devops_tools" {
  connection {
    type     = "ssh"
    host     = var.vm_public_ip
    user     = "docker"
    password = "Docker@12345"   # Or use key authentication
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
