#!/bin/bash
set -e

echo "🚀 Creating VM using Ansible playbook..."

ansible-playbook playbooks/create-vm-playbook.yml \
  -e "@vars/ansible-vars.yaml" \
  -e "@vars/global-vars.yaml"

echo "✅ VM created successfully!"
