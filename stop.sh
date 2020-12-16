#!/bin/bash
if [ $# -lt 1 ]; then
  echo ""
  echo "You must specify a server!"
  echo "Usage: $0 <server_name>"
  echo ""
  exit 1
fi

# Set variables to be used throughout script
SERVER_NAME=$1
WARNING_TIME=60

# Stop the server if it's not already stopped and give players
#   a chance to log out
if screen -list | grep -q "$SERVER_NAME"; then
  screen -p 0 -S $SERVER_NAME -X eval \
    "stuff \"say Stopping server for updates in ${WARNING_TIME} seconds.\"\015"
  while (($WARNING_TIME > 0));
  do
    if (($WARNING_TIME <= 10)); then
      screen -p 0 -S $SERVER_NAME -X eval \
        "stuff \"say Stopping server for updates in ${WARNING_TIME} seconds.\"\015"
    fi
    WARNING_TIME=$((${WARNING_TIME} - 1))
    sleep 1
  done
  screen -p 0 -S $SERVER_NAME -X eval "stuff \"stop\"\015"
  echo ""
  echo "$SERVER_NAME server is shutting down..."
  echo ""
  screen -S $SERVER_NAME -p 0 -X quit
  echo ""
else
  echo "$SERVER_NAME is already down!"
fi
