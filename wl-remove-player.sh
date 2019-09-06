#!/bin/bash
if [ -z "$1" ]; then
  echo ""
  echo "You must specify a player name!"
  echo ""
fi

# Make sure to execute from the scripts directory
cd /data/0/scripts

# Global lists of PLAYERS and SERVERS
SERVERS=server-list.txt
PLAYER=$1

# Loop through SERVERS
while read -r instance
do
  # Make sure server is running!
  if ! screen -list | grep -q "$instance"; then
    echo "$instance is NOT running!"
    break
  else
      screen -p 0 -S $instance -X eval "stuff \"whitelist remove $PLAYER\"\015"
      sleep 1
  fi
done < $SERVERS

