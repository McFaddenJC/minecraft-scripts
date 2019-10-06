#!/bin/bash
if [ $# -lt 1 ]; then
  echo "";
  echo "You must specify a server!";
  echo "";
  exit 0;
fi

# Loop through the server names and start them up here
if screen -list | grep -q "$1"; then
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down for updates in 30 seconds.\"\015"
  sleep 20
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 10 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 9 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 8 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 7 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 6 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 5 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 4 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 3 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 2 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"say Server will be shutting down in 1 seconds.\"\015"
  sleep 1
  screen -p 0 -S $1 -X eval "stuff \"stop\"\015"
  echo ""
  echo "$1 server is shutting down..."
  echo ""
  screen -S $1 -p 0 -X quit
  echo ""
else
  echo "$1 is already down!"
fi



