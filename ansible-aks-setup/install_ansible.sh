#!/bin/bash
set -e

echo "=== Installing Ansible and dependencies ==="
if command -v apt >/dev/null 2>&1; then
    sudo apt update -y
    sudo apt install -y ansible python3-pip
else
    sudo yum install -y epel-release || true
    sudo yum install -y ansible python3-pip
fi

echo "=== Installing Azure CLI ==="
if command -v apt >/dev/null 2>&1; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo yum install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
fi

echo "=== Loading Azure credentials ==="
source /home/docker/azure_env.sh

echo "=== Logging into Azure ==="
az login --service-principal -u $AZ_CLIENT_ID -p $AZ_CLIENT_SECRET --tenant $AZ_TENANT_ID
az account set --subscription $AZ_SUBSCRIPTION_ID

echo "=== Running Ansible playbook to deploy AKS ==="
ansible-playbook /home/docker/aks_playbook.yml

if [ $? -eq 0 ]; then
    echo "✅ Ansible playbook executed successfully!"
else
    echo "❌ Ansible playbook execution failed!"
    exit 1
fi

echo "=== AKS setup completed ==="
