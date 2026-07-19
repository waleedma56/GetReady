#!/usr/bin/env bash
#
# essentials.sh
# Prepare a fresh Proxmox / Ubuntu system after a clean install.
# Run as root:  bash essentials.sh   (or)   sudo bash essentials.sh
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

apt_install() {
    for pkg in "$@"; do
        if apt -qq install -y "$pkg" 2>/dev/null; then
            echo -e "${GREEN}[✓]${NC} $pkg installed"
        else
            echo -e "${RED}[✗]${NC} $pkg failed"
        fi
    done
}

# --- Ensure we are running as root (apt needs it) -------------------------
if [[ "${EUID}" -ne 0 ]]; then
    echo "This script must be run as root. Try: sudo bash essentials.sh"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "=========================================="
echo " Proxmox / Ubuntu Essentials Setup"
echo "=========================================="

echo ""
echo "[1/5] Updating package lists..."
apt -qq update

echo ""
echo "[2/5] Upgrading installed packages..."
apt -qq full-upgrade -y

echo ""
echo "[3/5] Installing essential packages..."
apt_install \
    curl \
    wget \
    git \
    nano \
    vim \
    htop \
    zip \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    sudo \
    bash-completion \
    rsync \
    tree \
    ncdu \
    python3 \
    python3-pip

echo ""
echo "[4/5] Installing networking tools..."
apt_install \
    net-tools \
    iputils-ping \
    dnsutils \
    nmap \
    traceroute \
    iftop \
    tcpdump

echo ""
echo "[5/5] Cleaning up..."
apt -qq autoremove -y
apt -qq autoclean

echo ""
echo "=========================================="
echo " Essentials installation completed!"
echo "=========================================="
