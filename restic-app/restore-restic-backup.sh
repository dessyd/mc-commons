#!/bin/bash

set -euo pipefail

: "${RCON_HOST:=mc}"
: "${WORLD_NAME:=world}"

: "${SRC_DIR:=/data}"
: "${DEBUG:=false}"

BUCKET=minecraft/${RCON_HOST:-mc}

export RESTIC_REPOSITORY=s3:http://192.168.1.15:9000/${BUCKET}
export RESTIC_PASSWORD
export RESTIC_HOST=${RCON_HOST}-backup
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY


if [[ ${DEBUG,,} = true ]]; then
  set -x
  echo ${RESTIC_REPOSITORY}
  echo ${RESTIC_PASSWORD}
  echo ${AWS_ACCESS_KEY_ID}
  echo ${AWS_SECRET_ACCESS_KEY}
  restic version
fi

echo "Host: ${RCON_HOST}, World: ${WORLD_NAME}"

if (( $(ls "$SRC_DIR" | wc -l) == 0 )); then
  if restic cat config >/dev/null 2>&1; then
    if (($(restic snapshots --host ${RESTIC_HOST} | wc -l) > 1)); then
      echo "Restoring latest snapshot to ${SRC_DIR}"
      restic restore latest:/data --target ${SRC_DIR} --host ${RESTIC_HOST}
    else
      echo "No backups available to restore"
    fi
  else
    echo "No repository available to restore from"
  fi
else
  echo "No restore needed"
fi