#!/bin/bash
set -e

echo "🚀 Starting Terraform AKS Deployment..."

WORK_DIR="infra/terraform/aks"
mkdir -p $WORK_DIR
cd $WORK_DIR

cat > main.tf <<EOF
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${terraform_aksName}"
  location            = "${location}"
  resource_group_name = "${resourceGroup}"
  dns_prefix          = "${terraform_aksName}"

  default_node_pool {
    name       = "default"
    node_count = ${terraform_aksNodeCount}
    vm_size    = "${terraform_aksNodeVMSize}"
  }

  identity {
    type = "SystemAssigned"
  }
}
EOF

terraform init \
  -backend-config="resource_group_name=${terraform_tfBackendRG}" \
  -backend-config="storage_account_name=${terraform_tfBackendStorage}" \
  -backend-config="container_name=${terraform_tfBackendContainer}" \
  -backend-config="key=${terraform_aksName}.tfstate"

terraform plan -out=tfplan
terraform apply -auto-approve tfplan

echo "✅ AKS Cluster '${terraform_aksName}' created successfully!"
