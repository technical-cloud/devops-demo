#!/bin/bash
set -e

echo "=== Installing Ansible and dependencies on RHEL ==="
sudo dnf install -y epel-release || sudo yum install -y epel-release
sudo dnf install -y ansible python3-pip unzip jq git curl || sudo yum install -y ansible python3-pip unzip jq git curl

echo "=== Installing Azure CLI ==="
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm || sudo yum install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
sudo dnf install -y azure-cli || sudo yum install -y azure-cli

echo "=== Loading Azure credentials ==="
if [ ! -f "/home/docker/azure_env.sh" ]; then
    echo "❌ ERROR: /home/docker/azure_env.sh not found!"
    exit 1
fi
source /home/docker/azure_env.sh

# Validate environment variables
if [[ -z "$AZ_SUBSCRIPTION_ID" || -z "$AZ_CLIENT_ID" || -z "$AZ_CLIENT_SECRET" || -z "$AZ_TENANT_ID" ]]; then
    echo "❌ ERROR: Azure environment variables are not set!"
    exit 1
fi

echo "=== Logging into Azure ==="
az login --service-principal \
         --username "$AZ_CLIENT_ID" \
         --password "$AZ_CLIENT_SECRET" \
         --tenant "$AZ_TENANT_ID" \
         --output none

az account set --subscription "$AZ_SUBSCRIPTION_ID"
echo "✅ Azure CLI login and subscription set successfully!"

# Run Ansible playbook
PLAYBOOK="/home/docker/aks_playbook.yml"
if [ ! -f "$PLAYBOOK" ]; then
    echo "❌ ERROR: Ansible playbook $PLAYBOOK not found!"
    exit 1
fi

echo "=== Running Ansible playbook to deploy AKS ==="
ansible-playbook "$PLAYBOOK"

echo "✅ Ansible playbook executed successfully!"
echo "=== AKS setup completed ==="
