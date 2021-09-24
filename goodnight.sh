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
MESSAGE="It's late! It's time to go to bed! I'm going to bed too! This is a 5 minute warning!"

screen -p 0 -S $SERVER_NAME -X eval "stuff \"say $MESSAGE\"\015"
