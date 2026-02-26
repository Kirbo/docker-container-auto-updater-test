#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

GREEN='\033[0;32m'
NC='\033[0m'

log() {
  echo -e "${GREEN}=== $* ===${NC}"
}

log "Updating apt"
apt update -y

log "Upgrading apt packages"
apt upgrade -y

log "Installing packages"
apt install -y \
    build-essential \
    curl \
    git \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg \
    imagemagick

log "Cleaning up apt"
apt-get autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*

VENV_DIR=/opt/venv
REQUIREMENTS_FILE=/app/requirements.txt

log "Creating virtual environment at ${VENV_DIR}"
python3 -m venv "${VENV_DIR}"

PIP="${VENV_DIR}/bin/pip"

log "Upgrading pip in venv"
"${PIP}" install --upgrade pip setuptools wheel

if [[ -f "${REQUIREMENTS_FILE}" ]]; then
  log "Installing Python dependencies from ${REQUIREMENTS_FILE}"
  "${PIP}" install --no-cache-dir -r "${REQUIREMENTS_FILE}"
else
  log "No requirements.txt found at ${REQUIREMENTS_FILE}, skipping pip install"
fi

NOW=$(date)
log "Update finished at ${NOW}"
log "Update took ${SECONDS} seconds"
