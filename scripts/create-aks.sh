#!/bin/bash
set -euo pipefail

echo "Starting AKS Terraform deployment"

# Login to Azure using service principal credentials
if [[ -z "${azure_client_id:-}" || -z "${azure_client_secret:-}" || -z "${azure_tenant_id:-}" || -z "${azure_subscription_id:-}" ]]; then
  echo "Azure login variables not set"
  exit 1
fi

echo "Logging in to Azure"
az login --service-principal \
  --username "$azure_client_id" \
  --password "$azure_client_secret" \
  --tenant "$azure_tenant_id" >/dev/null

az account set --subscription "$azure_subscription_id"

echo "Azure login successful"

# Enter Terraform directory (required)
echo "Entering Terraform directory"
cd terraform

echo "Initializing Terraform"
terraform init

echo "Planning Terraform changes"
terraform plan

echo "Applying Terraform"
terraform apply -auto-approve

echo "AKS Cluster deployed successfully"
