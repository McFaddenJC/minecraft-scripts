#!/bin/bash
if [ $# -lt 2 ]; then
  echo ""
  echo "You must specify a server!"
  echo "Usage: $0 <server_name> <message>"
  echo ""
  exit 1
fi

# Set variables to be used throughout script
SERVER_NAME=$1
MESSAGE=$2

screen -p 0 -S $SERVER_NAME -X eval "stuff \"say $MESSAGE\"\015"
