#!/bin/bash
set -e

exec > >(tee -i /var/log/cloudinit_stage2.log)
exec 2>&1

echo "Starting DevOps tools installation on RHEL..."

# Function to wait for yum/dnf locks
wait_for_yum() {
  echo "Waiting for any other yum/dnf process to finish..."
  while sudo fuser /var/run/yum.pid >/dev/null 2>&1 || sudo fuser /var/run/dnf.pid >/dev/null 2>&1; do
    echo "Yum/DNF lock detected. Sleeping for 5s..."
    sleep 5
  done
}

# -------------------------------
# Update packages & install essentials
# -------------------------------
wait_for_yum
echo "Updating packages..."
sudo dnf update -y || sudo yum update -y

wait_for_yum
echo "Installing git, unzip, curl, wget, epel-release..."
sudo dnf install -y git unzip curl wget epel-release || sudo yum install -y git unzip curl wget epel-release

# -------------------------------
# Install Docker
# -------------------------------
wait_for_yum
echo "Installing Docker..."
sudo dnf install -y docker || sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
docker --version

# -------------------------------
# Install Azure CLI
# -------------------------------
echo "Installing Azure CLI..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm || sudo yum install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
sudo dnf install -y azure-cli || sudo yum install -y azure-cli

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

echo "✅ All DevOps tools installed successfully on RHEL!"