#!/bin/bash

# Make sure to execute from the scripts directory
cd /data/0/scripts

# Global lists of PLAYERS and SERVERS
SERVERS=server-list.txt
PLAYERS=whitelist.txt

# Loop through SERVERS
while read -r instance
do
  # Make sure server is running!
  if ! screen -list | grep -q "$instance"; then
    echo "$instance is NOT running!"
    break
  else
    # Loop through PLAYERS
    while read -r player
    do
      # Add players to ops lists
      #  echo "$instance - $player"
      screen -p 0 -S $instance -X eval "stuff \"whitelist add $player\"\015"
      sleep 1
    done < $PLAYERS
    screen -p 0 -S $instance -X eval "stuff \"whitelist reload\"\015"
  fi
done < $SERVERS

