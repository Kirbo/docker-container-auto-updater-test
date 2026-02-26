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
branch=$(cat current-branch.txt 2>/dev/null || echo "main")
if [[ ! "${branch}" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
  log "Invalid branch name '${branch}', falling back to main"
  branch="main"
fi
git pull origin "${branch}" || log "No changes to pull"

log "Running update.sh"
bash /app/update.sh

log "Running run.sh"
exec bash /app/run.sh
