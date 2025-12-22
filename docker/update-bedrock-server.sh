#!/bin/bash
# Script to update a minecraft world

# Start by checking for the correct number of parameters
USAGE="Usage: $0 <server_name>"
if [ $# -lt 1 ]; then
  echo "Invalid number of arguments given"
  echo "$USAGE"
  echo ""
  exit 1
fi

# Set all script variables
SCRIPTS_DIR=/path to where you save this/
BASE_DIR=/path to where your worlds are/
SERVER_NAME=$1

if [ -e "$BASE_DIR/$SERVER_NAME/current_server" ]; then
  CURRENT_SERVER=$( cat "$BASE_DIR/$SERVER_NAME/current_server" )
else
  CURRENT_SERVER="unknown"
fi

# If the server download detects a different version from what is running, do the following:
#  The download script brings in the new server jar file and erases the previous one
$SCRIPTS_DIR/get-bedrock-docker-server.sh $SERVER_NAME
NEW_SERVER=$( cat "$BASE_DIR/$SERVER_NAME/current_server" )

if [ ! "$CURRENT_SERVER" == "$NEW_SERVER" ]; then
  # Stop the current running world
  cd $BASE_DIR/$SERVER_NAME
  docker-compose down
  docker-compose pull

  # Back up the current world
  #$SCRIPTS_DIR/sync-to-s3.sh jcs-minecraft-backups docker/$SERVER_NAME

  # Start the world back up using the new version
  docker-compose up -d
else
  echo "Server version has not changed. Nothing to do."
fi
