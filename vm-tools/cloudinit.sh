#!/bin/bash
set -e

exec > >(tee -i /var/log/cloudinit_stage2.log)
exec 2>&1

echo "Starting DevOps tools installation..."

echo "Updating packages..."
sudo apt-get update -y
sudo apt-get install -y git unzip curl apt-transport-https software-properties-common

echo "Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
docker --version

echo "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "Installing kubectl..."
curl -fLO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing Terraform 1.7.5..."
curl -fL -o terraform_1.7.5_linux_amd64.zip https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
unzip terraform_1.7.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.5_linux_amd64.zip

echo "Verifying tools..."
git --version
docker --version
az version
kubectl version --client
helm version
terraform -v

echo "✅ All DevOps tools installed successfully!"
