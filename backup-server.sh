#!/bin/bash
#
#  Script to backup minecraft worlds twice daily
#

if [ $# -lt 1 ]; then
  echo ""
  echo "Usage: $0 <server_name>"
  echo ""
else
  SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  BASE_DIR=$( sed 's|/scripts||g' <<< $SCRIPTS_DIR )
  TODAY=$(date +"%Y%m%d-%H.%M.%s")
  SERVER_NAME=$1
  CURRENT_SERVER=$( cat "$BASE_DIR/$SERVER_NAME/current_server" )

  echo "Switching to server directory"
  cd "$BASE_DIR/$SERVER_NAME"

  echo "Creating backup folder"
  mkdir -p "$BASE_DIR/$SERVER_NAME/backups"

  # Make sure the backup doesn't already exist
  if [ -e "$BASE_DIR/$SERVER_NAME/backups/$TODAY-$SERVER_NAME.tar.gz" ]; then
    echo "A backup for today has already been made"
  else
    echo "Creating archive of current world"
    tar -cvzf "$BASE_DIR/$SERVER_NAME/backups/$TODAY.$CURRENT_SERVER-$SERVER_NAME.tar.gz" world
    echo "Done creating world save"
  fi
fi
