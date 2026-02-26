#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

log() {
  echo -e "${GREEN}=== $* ===${NC}"
}

NOW=$(date)
log "Current date and time: ${NOW}"

log "Go to app directory"
cd /app

log "Git pull"
git pull origin main || log "No changes to pull"

log "Running update.sh"
bash /app/update.sh

log "Running run.sh"
exec bash /app/run.sh
