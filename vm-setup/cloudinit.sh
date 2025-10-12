#!/bin/bash
set -e

# -----------------------
# Log output
# -----------------------
exec > >(tee -i /var/log/cloudinit_stage1.log)
exec 2>&1

# -----------------------
# Update and install prerequisites
# -----------------------
echo "Updating system and installing unzip, curl..."
sudo apt-get update -y
sudo apt-get install -y unzip curl

# -----------------------
# Install Terraform
# -----------------------
echo "Installing Terraform..."
curl -fLO https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip
unzip terraform_1.7.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.6_linux_amd64.zip

echo "Stage 1 setup completed: VM created with Terraform installed."

# -----------------------
# Git installation
# -----------------------
echo "Installing Git, unzip, curl, and other dependencies..."
sudo apt-get install -y git unzip curl apt-transport-https software-properties-common