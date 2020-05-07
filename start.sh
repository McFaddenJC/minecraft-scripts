#!/bin/bash
if [ $# -lt 1 ]; then
  echo ""
  echo "You must specify a server!"
  echo "Usage: $0 <server_name>"
  echo ""
  exit 1
fi

# Set scripts folder
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )
SERVER_NAME=$1

# Check to see if server is already running before starting
if ! screen -list | grep -q "$SERVER_NAME"; then
  cd $BASE_DIR/$SERVER_NAME
  screen -dmS $SERVER_NAME
  sleep 2
  screen -p 0 -S $SERVER_NAME -X eval "stuff \"./launch.sh\"\015"
  echo "$SERVER_NAME server is starting..."
else
  echo "$SERVER_NAME appears to be running already!"
fi
