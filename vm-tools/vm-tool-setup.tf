variable "vm_public_ip" {
  description = "Public IP of the Ubuntu VM"
  type        = string
}

resource "null_resource" "install_devops_tools" {
  connection {
    type     = "ssh"
    host     = var.vm_public_ip
    user     = "docker"
    password = "Docker@12345"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y git unzip curl docker.io apt-transport-https software-properties-common",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -aG docker docker",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | bash",
      "curl -fLO https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
      "rm -f kubectl",
      "curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
    ]
  }
}
