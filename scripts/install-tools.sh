#!/bin/bash
set -euo pipefail

echo "🔧 Installing base tools..."

# ---------------------------------------------------------------------
# 🧩 Handle apt lock safely (wait if another process is running)
# ---------------------------------------------------------------------
echo "⏳ Checking for existing apt lock..."
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  echo "⚠️  Another apt process is running. Waiting 10s..."
  sleep 10
done

# ---------------------------------------------------------------------
# 🧰 Update & install base dependencies
# ---------------------------------------------------------------------
echo "📦 Updating system packages..."
sudo apt-get update -y -o Acquire::Retries=3
sudo apt-get install -y jq unzip curl wget software-properties-common apt-transport-https ca-certificates lsb-release gnupg --no-install-recommends

# ---------------------------------------------------------------------
# 🐍 Python + Ansible
# ---------------------------------------------------------------------
echo "✅ Installing Python & Ansible"
sudo apt-get install -y python3-pip
pip install --quiet ansible --break-system-packages

# ---------------------------------------------------------------------
# ☁️ Azure CLI
# ---------------------------------------------------------------------
echo "✅ Installing Azure CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# ---------------------------------------------------------------------
# 🌍 Terraform
# ---------------------------------------------------------------------
echo "✅ Installing Terraform"
T_VERSION="1.9.8"
wget -q https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip
unzip -o terraform_${T_VERSION}_linux_amd64.zip >/dev/null
sudo mv terraform /usr/local/bin/
terraform version

# ---------------------------------------------------------------------
# ⚓ Helm
# ---------------------------------------------------------------------
echo "✅ Installing Helm"
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ---------------------------------------------------------------------
# 🐳 Docker
# ---------------------------------------------------------------------
echo "✅ Installing Docker"
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "$(whoami)"
docker --version

# ---------------------------------------------------------------------
# ☸️ kubectl
# ---------------------------------------------------------------------
echo "✅ Installing kubectl"
K_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${K_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

echo "🎉 All tools installed successfully!"