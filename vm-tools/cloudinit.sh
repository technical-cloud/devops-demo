#!/bin/bash
set -e

# -------------------------------
# Logging
# -------------------------------
exec > >(tee -i /var/log/cloudinit.log)
exec 2>&1

echo "Starting DevOps tools installation on Ubuntu VM..."

# -------------------------------
# Update system and install essentials
# -------------------------------
echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get install -y git unzip curl apt-transport-https software-properties-common

# -------------------------------
# Install Docker
# -------------------------------
echo "Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Add default user to docker group to avoid sudo for docker
sudo usermod -aG docker $USER

# Verify Docker installation
docker --version

# -------------------------------
# Install Azure CLI
# -------------------------------
echo "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# -------------------------------
# Install kubectl
# -------------------------------
echo "Installing kubectl..."
curl -fLO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# -------------------------------
# Install Helm
# -------------------------------
echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# -------------------------------
# Install Terraform
# -------------------------------
echo "Installing Terraform..."
curl -fLO https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip
unzip terraform_1.7.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.6_linux_amd64.zip

# -------------------------------
# Final verification
# -------------------------------
echo "Verifying installed tools..."
git --version
docker --version
az version
kubectl version --client
helm version
terraform -v

echo "✅ All DevOps tools installed successfully!"
