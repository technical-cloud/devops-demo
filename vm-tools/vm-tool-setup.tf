variable "vm_public_ip" {}
variable "ado_pat" {}
variable "agent_user" { default = "docker" }
variable "agent_pass" { default = "Docker@12345" }

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
      "sudo /tmp/cloudinit.sh ${var.ado_pat}"
    ]
  }
}
