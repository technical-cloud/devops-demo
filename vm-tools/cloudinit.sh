#!/bin/bash
set -e

# Log all output
exec > >(tee -i /var/log/cloudinit.log)
exec 2>&1

# -----------------------
# Update and install essential tools
# -----------------------
echo "Updating system..."
sudo apt-get update -y

echo "Installing Git, unzip, curl, and other dependencies..."
sudo apt-get install -y git unzip curl apt-transport-https software-properties-common

# -----------------------
# Docker setup
# -----------------------
echo "Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker docker

# -----------------------
# Azure CLI
# -----------------------
echo "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# -----------------------
# Kubernetes CLI (kubectl)
# -----------------------
echo "Installing kubectl..."
curl -fLO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# -----------------------
# Helm
# -----------------------
echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# -----------------------
# Terraform
# -----------------------
echo "Installing Terraform..."
curl -fLO https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip
unzip terraform_1.7.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.6_linux_amd64.zip

echo "Git and all DevOps tools installed successfully!"
