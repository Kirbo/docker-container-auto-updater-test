#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

log() {
  echo -e "${GREEN}=== $* ===${NC}"
}

PYTHON=/opt/venv/bin/python
APP_CMD=/app/main.py

log "Running main.py with venv python"
exec "${PYTHON}" "${APP_CMD}"
