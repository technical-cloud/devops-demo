#!/bin/bash
set -e

ADO_PAT=$1  # Get the PAT from argument

# -------------------------------
# Logging
# -------------------------------
exec > >(tee -i /var/log/cloudinit.log)
exec 2>&1

echo "Starting DevOps tools installation on Ubuntu VM..."
echo "Using Azure DevOps PAT: $ADO_PAT"

# -------------------------------
# Update system and install essentials
# -------------------------------
sudo yum update -y
sudo yum install -y git unzip curl apt-transport-https software-properties-common

# -------------------------------
# Install Docker
# -------------------------------
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
docker --version

# -------------------------------
# Install Azure CLI
# -------------------------------
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# -------------------------------
# Install kubectl
# -------------------------------
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# -------------------------------
# Install Helm
# -------------------------------
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# -------------------------------
# Install Terraform
# -------------------------------
curl -fLO https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip
unzip terraform_1.7.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.6_linux_amd64.zip

# -------------------------------
# Final verification
# -------------------------------
git --version
docker --version
az version
kubectl version --client
helm version
terraform -v

echo "✅ All DevOps tools installed successfully!"
