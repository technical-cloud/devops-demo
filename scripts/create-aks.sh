#!/bin/bash
set -euo pipefail

echo "Starting AKS Terraform deployment"

echo "Terraform environment variables configured"

echo "Entering Terraform directory"
cd terraform

echo "Initializing Terraform"
terraform init

echo "Planning Terraform changes"
terraform plan

echo "Applying Terraform"
terraform apply -auto-approve

echo "AKS Cluster deployed successfully"
