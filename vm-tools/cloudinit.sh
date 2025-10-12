#!/bin/bash
set -e

exec > >(tee -i /var/log/cloudinit_stage2.log)
exec 2>&1

echo "Starting DevOps tools installation..."

# Function to wait for apt locks
wait_for_apt() {
  echo "Waiting for any other apt/dpkg process to finish..."
  while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
        sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
        sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Apt lock detected. Sleeping for 5s..."
    sleep 5
  done
}

# -------------------------------
# Update packages & install essentials
# -------------------------------
wait_for_apt
echo "Updating packages..."
sudo apt-get update -y

wait_for_apt
echo "Installing git, unzip, curl, apt-transport-https, software-properties-common..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git unzip curl apt-transport-https software-properties-common

# -------------------------------
# Install Docker
# -------------------------------
wait_for_apt
echo "Installing Docker..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
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
echo "Installing Terraform 1.7.5..."
curl -fL -o terraform_1.7.5_linux_amd64.zip https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
unzip terraform_1.7.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.5_linux_amd64.zip

# -------------------------------
# Verify installations
# -------------------------------
echo "Verifying tools..."
git --version
docker --version
az version
kubectl version --client
helm version
terraform -v

echo "✅ All DevOps tools installed successfully!"
