#!/bin/bash
set -euo pipefail

echo "🚀 Creating VM using Ansible playbook..."

################################################################################
# ✅ ACTIVATE PYTHON VENV (Ansible was installed inside venv)
################################################################################
if [ -d "$HOME/pyenv/bin" ]; then
    echo "✅ Activating Python virtual environment..."
    source "$HOME/pyenv/bin/activate"
else
    echo "❌ Python venv not found at $HOME/pyenv"
    echo "   Run install-tools stage first."
    exit 1
fi

################################################################################
# ✅ CHECK ANSIBLE INSTALLATION
################################################################################
if ! command -v ansible-playbook >/dev/null 2>&1; then
    echo "❌ ansible-playbook not found in PATH!"
    echo "   It must be installed inside the venv by install-tools.sh"
    exit 1
fi

echo "✅ Ansible detected: $(ansible-playbook --version | head -n 1)"

################################################################################
# ✅ RUN THE VM CREATION PLAYBOOK
################################################################################
# We assume workingDirectory: $(Build.SourcesDirectory) is set in YAML
# so relative paths (playbooks/, vars/) will resolve correctly.

ansible-playbook playbooks/create-vm-playbook.yaml 

################################################################################
# ✅ SUCCESS MESSAGE
################################################################################
echo "✅ VM created successfully!"
