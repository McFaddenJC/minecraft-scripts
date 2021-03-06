#!/bin/bash
#
#  Script to start up the BlueMap rendered from local worlds
#

# Display Useage
#USAGE="Usage: $0"
#if [ $# -lt 0 ]; then
#  echo "Invalid number of arguments given"
#  echo "$USAGE"
#  echo ""
#  exit 1
#fi

# Set scripts folder
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )

# Locate server list file
FILE=$SCRIPTS_DIR/server-list.txt

# Get list of servers to process
while read -r SERVER_NAME
do
  # Get target folder based on server name
  if [ -e "${BASE_DIR}/${SERVER_NAME}web" ]; then
    # Get the port to listen on
    WEB=$(grep -i "port:" ${BASE_DIR}/${SERVER_NAME}web/webserver.conf)
    WEBPORT=$(echo "${WEB: -4}")
    #echo "Web String: $WEB"
    #echo "Web Port: $WEBPORT"

    # Check to see if there is already a screen running for that web port
    if screen -list | grep -q "${WEBPORT}web"; then
      screen -S ${WEBPORT}web -p 0 -X quit
      echo "${WEBPORT}web map server shutting down..."
    else
      echo "${WEBPORT}web is already stopped..."
    fi
  fi
done < "$FILE"
