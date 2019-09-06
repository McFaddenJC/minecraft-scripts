#!/bin/bash
if [ -z "$1" ]; then
  echo ""
  echo "You must specify a server!"
  echo ""
fi

# Loop through the server names and start them up here
if ! screen -list | grep -q "$1"; then
  #screen -S $1 -dmS /opt/minecraft/$1/launch.sh
  cd /data/0/$1
  screen -dmS $1
  sleep 2
  screen -p 0 -S $1 -X eval "stuff \"./launch.sh\"\015"
  echo "$1 server is starting..."
else
  echo "$1 appears to be running already!"
fi

