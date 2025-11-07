#!/bin/bash
set -euo pipefail

################################################################################
# COLORS
################################################################################
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
NC="\e[0m" # No Color

log()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; }

log "🔧 Starting Installation of Required Tools..."

################################################################################
# APT LOCK HANDLING
################################################################################
log "⏳ Checking for existing apt lock (retrying if needed)..."
max_retries=30
retry_count=0

while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    if (( retry_count >= max_retries )); then
        warn "APT lock held too long — forcing cleanup..."
        sudo killall apt apt-get || true
        sudo rm -f /var/lib/dpkg/lock-frontend || true
        sudo rm -f /var/lib/apt/lists/lock || true
        sudo dpkg --configure -a || true
        break
    fi
    warn "Another apt process is running. Waiting 10s... ($retry_count/$max_retries)"
    retry_count=$((retry_count+1))
    sleep 10
done

################################################################################
# BASE DEPENDENCIES
################################################################################
log "📦 Installing base dependencies…"

sudo apt-get update -y
sudo apt-get install -y jq unzip curl software-properties-common apt-transport-https \
    ca-certificates lsb-release gnupg python3-venv python3-full

################################################################################
# PYTHON + ANSIBLE IN VENV (PEP 668 SAFE)
################################################################################
log "🐍 Setting up Python virtual environment (PEP 668 safe)..."

mkdir -p "$HOME/pyenv"
if [ ! -d "$HOME/pyenv/bin" ]; then
    python3 -m venv "$HOME/pyenv"
fi

source "$HOME/pyenv/bin/activate"
pip install --quiet --upgrade pip
pip install --quiet ansible

ansible --version || warn "Ansible installed but version check failed."

################################################################################
# AZURE CLI
################################################################################
log "☁️ Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

################################################################################
# TERRAFORM CLEANUP + INSTALL
################################################################################
log "📦 Installing Terraform…"

T_VERSION="1.9.8"

# ✅ Remove terraform folder in workspace (most common cause)
if [ -d "terraform" ]; then
    warn "Workspace contains a Terraform directory — removing to avoid conflicts..."
    rm -rf terraform || true
fi

# ✅ Remove immutable flags on system terraform
sudo chattr -i /usr/local/bin/terraform 2>/dev/null || true
sudo chattr -a /usr/local/bin/terraform 2>/dev/null || true

# ✅ Remove all system Terraform paths
log "🧹 Cleaning old Terraform installations..."
for path in \
    /usr/local/bin/terraform \
    /usr/bin/terraform \
    /bin/terraform \
    /usr/local/sbin/terraform \
    "$HOME/.local/bin/terraform" \
    "$HOME/pyenv/bin/terraform"; do

    if [ -e "$path" ]; then
        warn "Removing: $path"
        sudo rm -rf "$path" || rm -rf "$path" || true
    fi
done

# ✅ Download Terraform
log "⬇️ Downloading Terraform $T_VERSION..."
wget -q "https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip"
unzip -qo "terraform_${T_VERSION}_linux_amd64.zip"

sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
rm -f "terraform_${T_VERSION}_linux_amd64.zip"

terraform version

################################################################################
# HELM
################################################################################
log "⛵ Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

################################################################################
# DOCKER ENGINE
################################################################################
log "🐳 Installing Docker…"

sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

if ! command -v docker >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io || {
        err "Docker installation failed."
        exit 1
    }
fi

sudo usermod -aG docker "$(whoami)"
docker --version || warn "Docker installed but version check failed."

################################################################################
# KUBECTL
################################################################################
log "☸️ Installing kubectl..."
K_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${K_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client || warn "kubectl installed but version check failed."

################################################################################
# SUCCESS
################################################################################
log "🎉 All tools installed successfully!"
