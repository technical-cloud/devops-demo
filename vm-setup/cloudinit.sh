#!/bin/bash
set -e

# -------------------------------
# Update system and install prerequisites
# -------------------------------
echo "Updating system packages..."
sudo yum update -y
sudo yum install -y unzip curl git

# -------------------------------
# Install Terraform
# -------------------------------
echo "Installing Terraform..."
curl -fLO https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip
unzip terraform_1.7.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.6_linux_amd64.zip

# -------------------------------
# Final message
# -------------------------------
echo "✅ VM prepared! Terraform is installed."
terraform -v
