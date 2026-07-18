#!/usr/bin/env bash
#
# docker.sh
# Install Docker Engine + Docker Compose (v2 plugin) on Ubuntu / Debian,
# using Docker's official apt repository, then verify everything works.
# Run as root:  bash docker.sh   (or)   sudo bash docker.sh
#

set -euo pipefail

# --- Ensure we are running as root (apt needs it) -------------------------
if [[ "${EUID}" -ne 0 ]]; then
    echo "This script must be run as root. Try: sudo bash docker.sh"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "=========================================="
echo " Docker + Docker Compose Setup"
echo "=========================================="

# --- Detect distribution --------------------------------------------------
if [[ ! -r /etc/os-release ]]; then
    echo "Cannot detect the operating system (/etc/os-release missing)."
    exit 1
fi
# shellcheck disable=SC1091
. /etc/os-release

case "${ID}" in
    ubuntu|debian)
        DISTRO="${ID}"
        ;;
    *)
        # Derive from ID_LIKE for derivatives (e.g. Linux Mint, Raspbian, Pop!_OS)
        if [[ "${ID_LIKE:-}" == *ubuntu* ]]; then
            DISTRO="ubuntu"
        elif [[ "${ID_LIKE:-}" == *debian* ]]; then
            DISTRO="debian"
        else
            echo "Unsupported distribution: ${ID}. This script supports Ubuntu and Debian."
            exit 1
        fi
        ;;
esac

# Codename: prefer VERSION_CODENAME, fall back to lsb_release.
CODENAME="${VERSION_CODENAME:-${UBUNTU_CODENAME:-}}"
if [[ -z "${CODENAME}" ]] && command -v lsb_release >/dev/null 2>&1; then
    CODENAME="$(lsb_release -cs)"
fi
if [[ -z "${CODENAME}" ]]; then
    echo "Could not determine the distribution codename."
    exit 1
fi

echo ""
echo "Detected: ${PRETTY_NAME:-${ID}} (repo: ${DISTRO}, codename: ${CODENAME})"

# --- 1. Remove old / conflicting packages ---------------------------------
echo ""
echo "[1/6] Removing any old Docker packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    apt-get remove -y "${pkg}" >/dev/null 2>&1 || true
done

# --- 2. Prerequisites -----------------------------------------------------
echo ""
echo "[2/6] Installing prerequisites..."
apt-get update
apt-get install -y ca-certificates curl gnupg

# --- 3. Add Docker's official GPG key -------------------------------------
echo ""
echo "[3/6] Adding Docker's official GPG key and repository..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/${DISTRO}/gpg" -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

ARCH="$(dpkg --print-architecture)"
echo \
  "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${DISTRO} ${CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list

# --- 4. Install Docker Engine + Compose plugin ----------------------------
echo ""
echo "[4/6] Installing Docker Engine, CLI, containerd, Buildx and Compose..."
apt-get update
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# --- 5. Enable & start the service ----------------------------------------
echo ""
echo "[5/6] Enabling and starting the Docker service..."
if command -v systemctl >/dev/null 2>&1; then
    systemctl enable --now docker >/dev/null 2>&1 || systemctl start docker || true
else
    service docker start || true
fi

# Add the invoking (non-root) user to the docker group for rootless CLI use.
REAL_USER="${SUDO_USER:-}"
if [[ -n "${REAL_USER}" && "${REAL_USER}" != "root" ]]; then
    usermod -aG docker "${REAL_USER}" || true
    echo "Added user '${REAL_USER}' to the 'docker' group."
    echo "  (Log out and back in, or run 'newgrp docker', to use docker without sudo.)"
fi

# --- 6. Verify the installation -------------------------------------------
echo ""
echo "[6/6] Verifying the installation..."
echo "------------------------------------------"

FAIL=0

if docker --version; then
    echo "  [OK] Docker Engine present."
else
    echo "  [FAIL] 'docker --version' failed."
    FAIL=1
fi

if docker compose version; then
    echo "  [OK] Docker Compose plugin present."
else
    echo "  [FAIL] 'docker compose version' failed."
    FAIL=1
fi

# Is the daemon actually up?
if docker info >/dev/null 2>&1; then
    echo "  [OK] Docker daemon is running."
else
    echo "  [FAIL] Docker daemon is not responding."
    FAIL=1
fi

# Functional smoke test: run the official hello-world container.
echo ""
echo "Running 'hello-world' container as a functional test..."
if docker run --rm hello-world >/dev/null 2>&1; then
    echo "  [OK] hello-world container ran successfully."
else
    echo "  [FAIL] Could not run the hello-world container."
    FAIL=1
fi

echo "------------------------------------------"
echo ""
echo "=========================================="
if [[ "${FAIL}" -eq 0 ]]; then
    echo " Docker installation completed & verified!"
    echo ""
    echo " Versions:"
    echo "   $(docker --version)"
    echo "   $(docker compose version)"
    echo "=========================================="
    exit 0
else
    echo " Docker installation FINISHED WITH ERRORS."
    echo " Review the [FAIL] lines above."
    echo "=========================================="
    exit 1
fi
