#!/bin/bash
set -e

echo "=== Installing Ansible ==="
sudo apt update -y || sudo yum update -y
sudo apt install -y ansible python3-pip || sudo yum install -y ansible python3-pip

echo "=== Installing Azure CLI and dependencies ==="
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash || sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo "=== Logging into Azure ==="
source /home/docker/azure_env.sh
az login --service-principal -u $AZ_CLIENT_ID -p $AZ_CLIENT_SECRET --tenant $AZ_TENANT_ID
az account set --subscription $AZ_SUBSCRIPTION_ID

echo "=== Running Ansible playbook for AKS ==="
ansible-playbook /home/docker/aks_playbook.yml
if [ $? -eq 0 ]; then
    echo "✅ Ansible playbook executed successfully!"
else
    echo "❌ Ansible playbook execution failed!"
    exit 1
fi
echo "=== AKS setup completed ==="