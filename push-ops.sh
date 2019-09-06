#!/bin/bash

# Make sure to execute from the scripts directory
cd /data/0/scripts

# Global lists of PLAYERS and SERVERS
SERVERS=server-list.txt
PLAYERS=whitelist.txt

# Loop through SERVERS
while read -r instance
do
  # Check server.properties for "allow-ops=true"
  if cat /data/0/$instance/server.properties | grep -q "allow-ops=true"; then
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
        screen -p 0 -S $instance -X eval "stuff \"op $player\"\015"
      done < "$PLAYERS"
    fi
  fi
done < "$SERVERS"

