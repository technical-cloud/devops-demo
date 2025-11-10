#!/bin/bash
set -euo pipefail

echo "Starting AKS Terraform deployment"

# Optional: check if terraform directory exists
if [ ! -d "terraform" ]; then
  echo "Error: terraform directory not found!"
  exit 1
fi

echo "Entering Terraform directory"
cd terraform

echo "Initializing Terraform"
terraform init

echo "Planning Terraform changes"
terraform plan -out=tfplan

echo "Applying Terraform"
terraform apply -auto-approve tfplan

echo "AKS Cluster deployed successfully"
