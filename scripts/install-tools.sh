#!/bin/bash
set -e

echo "🔧 Installing base tools..."
sudo apt-get update -y
sudo apt-get install -y jq unzip curl software-properties-common apt-transport-https ca-certificates lsb-release gnupg

echo "✅ Installing Python & Ansible"
sudo apt-get install -y python3-pip
pip install ansible --quiet

echo "✅ Installing Azure CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "✅ Installing Terraform"
T_VERSION="1.9.8"
wget -q https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip
unzip terraform_${T_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version

echo "✅ Installing Helm"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "✅ Installing Docker"
sudo apt-get remove docker docker-engine docker.io containerd runc -y || true
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $(whoami)
docker --version

echo "✅ Installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

echo "🎉 All tools installed successfully!"