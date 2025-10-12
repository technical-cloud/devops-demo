#!/bin/bash
set -e

# Log all output
exec > >(tee -i /var/log/cloudinit.log)
exec 2>&1

# Update and install essential tools
apt-get update -y
apt-get install -y git unzip curl apt-transport-https software-properties-common docker.io

# Docker setup
systemctl enable docker
systemctl start docker
usermod -aG docker docker

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Kubernetes CLI (kubectl)
curl -fLO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Terraform
curl -fLO https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip
unzip terraform_1.7.6_linux_amd64.zip
mv terraform /usr/local/bin/
chmod +x /usr/local/bin/terraform
rm terraform_1.7.6_linux_amd64.zip