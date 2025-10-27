#!/bin/bash
set -e

echo "🔑 Logging into Azure using Service Principal..."
az login --service-principal \
  -u "$azure_client_id" \
  -p "$azure_client_secret" \
  --tenant "$azure_tenant_id" >/dev/null

az account set --subscription "$azure_subscription_id"
echo "✅ Azure login successful!"
