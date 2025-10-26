#!/bin/bash
set -e

echo "🚀 Creating VM with Ansible..."
echo "Resource Group: $resourceGroup"
echo "Location: $location"
echo "VM Name: $ansible_vmName"
echo "VM Size: $ansible_vmSize"
echo "VM Image: $ansible_vmImage"
echo "Admin User: $ansible_adminUser"
echo "SSH Key Path: $ansible_sshKeyPath"

# Create Resource Group if not exists
az group create --name "$resourceGroup" --location "$location"

# Using ansible ad-hoc command to run Azure CLI (no playbook)
ansible localhost -m shell -a "
  az vm create \
    --resource-group $resourceGroup \
    --name $ansible_vmName \
    --image $ansible_vmImage \
    --size $ansible_vmSize \
    --admin-username $ansible_adminUser \
    --ssh-key-values $ansible_sshKeyPath \
    --location $location
"

echo "✅ VM created successfully!"
