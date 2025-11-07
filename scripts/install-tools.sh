#!/bin/bash
set -euo pipefail

echo "🔧 Installing base tools..."

# 🧩 Handle apt lock safely with timeout & fallback
max_retries=30
retry_count=0

echo "⏳ Checking for existing apt lock..."
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  if [ $retry_count -ge $max_retries ]; then
    echo "❌ APT lock held too long. Forcing cleanup..."
    sudo killall apt apt-get || true
    sudo rm -f /var/lib/dpkg/lock-frontend
    sudo rm -f /var/lib/apt/lists/lock
    sudo dpkg --configure -a || true
    break
  fi
  echo "⚠️  Another apt process is running. Waiting 10s... ($retry_count/$max_retries)"
  retry_count=$((retry_count + 1))
  sleep 10
done

# 🧰 Update and install base dependencies
sudo apt-get update -y
sudo apt-get install -y jq unzip curl software-properties-common apt-transport-https \
  ca-certificates lsb-release gnupg python3-venv python3-full

echo "✅ Installing Python & Ansible (inside venv to avoid PEP 668)..."

# ✅ Create virtual env for Python tools
mkdir -p $HOME/pyenv
if [ ! -d "$HOME/pyenv/bin" ]; then
    python3 -m venv $HOME/pyenv
fi

# ✅ Activate venv
source $HOME/pyenv/bin/activate

# ✅ Install pip safely inside venv
pip install --upgrade pip
pip install ansible

# ✅ Confirm Ansible version
ansible --version || true

echo "✅ Installing Azure CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "✅ Installing Terraform"
T_VERSION="1.9.8"

# ✅ Remove broken or old Terraform (file OR directory)
if [ -e "/usr/local/bin/terraform" ]; then
    echo "⚠️ Removing old Terraform binary/directory..."
    sudo rm -rf /usr/local/bin/terraform
fi

# ✅ Download fresh Terraform
wget -q "https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip"
unzip -qo "terraform_${T_VERSION}_linux_amd64.zip"

# ✅ Move clean terraform binary
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform

rm -f "terraform_${T_VERSION}_linux_amd64.zip"

# ✅ Verify Terraform
terraform version

echo "✅ Installing Helm"
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "✅ Installing Docker"
# Remove conflicting versions
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

# Install official Docker CE repo
if ! command -v docker >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

sudo usermod -aG docker "$(whoami)"
docker --version || true

echo "✅ Installing kubectl"
K_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${K_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client || true

echo "🎉 All tools installed successfully!"
