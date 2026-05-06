#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="ci-lab-image"
CONTAINER_NAME="ci-lab1"
URL="http://127.0.0.1:5050/health"

log(){
  local level="$1"
  local message="$2"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
}

cleanup() {
  log "PROCESS" "Cleaning up container after test"
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}

trap cleanup EXIT

log "WARNING" "Clearing old container if it exists"
cleanup

log "PROCESS" "Creating the image"
docker build -t "$IMAGE_NAME" .

log "PROCESS" "The container will be started now"
docker run -d --name "$CONTAINER_NAME" -p 5050:5050 "$IMAGE_NAME"

sleep 5

log "PROCESS" "Checking the status code of the application"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL") || STATUS_CODE="000"

if [[ "$STATUS_CODE" == "200" ]]; then
  log "SUCCESS" "The API was successfully tested and returned HTTP 200"
  exit 0
fi

log "FAILED" "The API failed with status: $STATUS_CODE"
exit 1
