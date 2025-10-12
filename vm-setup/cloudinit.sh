#!/bin/bash
set -e

# Update and install prerequisites
sudo apt-get update -y
sudo apt-get install -y unzip curl git

# Install Terraform
curl -fLO https://releases.hashicorp.com/terraform/1.7.6/terraform_1.7.6_linux_amd64.zip
unzip terraform_1.7.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm terraform_1.7.6_linux_amd64.zip

echo "VM prepared! Terraform is installed."