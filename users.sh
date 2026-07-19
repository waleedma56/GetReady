#!/usr/bin/env bash
#
# users.sh
# Create a new user with SSH access and sudo privileges.
# Run as root:  bash users.sh   (or)   sudo bash users.sh
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

msg_ok()  { echo -e "${GREEN}[✓]${NC} $1"; }
msg_err() { echo -e "${RED}[✗]${NC} $1"; }
msg_inf() { echo -e "${YELLOW}[i]${NC} $1"; }

check_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        echo "This script must be run as root. Try: sudo bash users.sh"
        exit 1
    fi
}

add_sudo_user() {
    local username="$1"
    if id "$username" >/dev/null 2>&1; then
        msg_ok "User '$username' already exists"
    else
        useradd -m -s /bin/bash "$username"
        msg_ok "User '$username' created"
    fi
    usermod -aG sudo "$username"
    msg_ok "User '$username' added to sudo group"
}

setup_ssh_for_user() {
    local username="$1"
    local ssh_dir="/home/$username/.ssh"
    local auth_keys="$ssh_dir/authorized_keys"

    if [[ ! -d "$ssh_dir" ]]; then
        mkdir -p "$ssh_dir"
        msg_ok "Created .ssh directory for $username"
    else
        msg_inf ".ssh directory already exists for $username"
    fi

    chmod 700 "$ssh_dir"
    chown "${username}:${username}" "$ssh_dir"

    if [[ -f "$auth_keys" ]] && [[ -s "$auth_keys" ]]; then
        msg_inf "authorized_keys already exists for $username ($(wc -l < "$auth_keys") keys)"
        read -p "Append new keys? [y/N]: " -n 1 -r reply; echo
        if [[ ! "$reply" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi

    echo ""
    msg_inf "Paste public key(s) for $username (Ctrl+D to finish):"
    echo "----------------------------------------------------------------"
    cat >> "$auth_keys"
    echo "----------------------------------------------------------------"
    chmod 600 "$auth_keys"
    chown "${username}:${username}" "$auth_keys"
    msg_ok "authorized_keys updated for $username"
}

disable_root_ssh() {
    local sed_cmd
    if sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config 2>/dev/null; then
        msg_ok "Root login disabled in /etc/ssh/sshd_config"
    else
        msg_err "Could not disable root login in sshd_config"
    fi

    if systemctl restart sshd 2>/dev/null; then
        msg_ok "SSHD restarted"
    elif systemctl restart ssh 2>/dev/null; then
        msg_ok "SSH restarted"
    else
        msg_inf "Could not restart SSHD - you may need to restart it manually"
    fi
}

check_root

echo "=========================================="
echo "       SSH + Sudo User Setup"
echo "=========================================="
echo ""

read -p "Enter username to create: " username
if [[ -z "$username" ]]; then
    msg_err "Username cannot be empty"
    exit 1
fi
if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    msg_err "Invalid username. Use lowercase letters, numbers, _ and -"
    exit 1
fi

echo ""
echo "--- Creating user ---"
add_sudo_user "$username"

echo ""
echo "--- Setting up SSH ---"
setup_ssh_for_user "$username"

echo ""
read -p "Disable root SSH login? [y/N]: " -n 1 -r reply; echo
if [[ "$reply" =~ ^[Yy]$ ]]; then
    echo ""
    echo "--- Hardening SSH ---"
    disable_root_ssh
fi

echo ""
echo "=========================================="
echo " User setup completed!"
echo "=========================================="
echo ""
echo "  Username : $username"
echo "  SSH dir  : /home/$username/.ssh"
echo "  Sudo     : yes (members of sudo group)"
echo ""
echo "  Test sudo: sudo -l -U $username"
echo "  Test SSH : ssh -i ~/.ssh/id_rsa $username@<host>"
echo "=========================================="
