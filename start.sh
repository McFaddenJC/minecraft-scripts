#!/bin/bash
if [ $# -lt 1 ]; then
  echo ""
  echo "You must specify a server!"
  echo ""
  exit 0;
fi

# Set scripts folder
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )

# Loop through the server names and start them up here
if ! screen -list | grep -q "$1"; then
  cd $BASE_DIR/$1
  screen -dmS $1
  sleep 2
  screen -p 0 -S $1 -X eval "stuff \"./launch.sh\"\015"
  echo "$1 server is starting..."
else
  echo "$1 appears to be running already!"
fi

