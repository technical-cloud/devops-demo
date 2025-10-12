#!/bin/bash
set -e

# Logging
exec > >(tee -i /var/log/cloudinit_stage1.log)
exec 2>&1

echo "Updating system packages..."
sudo yum update -y || sudo apt-get update -y
sudo yum install -y unzip curl git || sudo apt-get install -y unzip curl git

echo "Installing Terraform 1.7.5..."
curl -fL -o terraform_1.7.5_linux_amd64.zip https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
unzip terraform_1.7.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.5_linux_amd64.zip

echo "✅ VM prepared! Terraform installed."
terraform -v
