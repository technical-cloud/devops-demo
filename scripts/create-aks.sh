#!/bin/bash
set -e
cd terraform

echo "🚀 Starting AKS Terraform deployment..."

terraform init -input=false
terraform apply -auto-approve

echo "✅ AKS Cluster deployed successfully!"
