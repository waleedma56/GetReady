#!/usr/bin/env bash
#
# essentials.sh
# Prepare a fresh Proxmox / Ubuntu system after a clean install.
# Run as root:  bash essentials.sh   (or)   sudo bash essentials.sh
#

set -euo pipefail

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
apt update

echo ""
echo "[2/5] Upgrading installed packages..."
apt -y full-upgrade

echo ""
echo "[3/5] Installing essential packages..."
apt -y install \
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
    bash-completion

echo ""
echo "[4/5] Installing networking tools..."
apt -y install \
    net-tools \
    iputils-ping \
    dnsutils \
    nmap \
    traceroute \
    iftop \
    tcpdump

echo ""
echo "[5/5] Cleaning up..."
apt autoremove -y
apt autoclean

echo ""
echo "=========================================="
echo " Essentials installation completed!"
echo "=========================================="
