#!/bin/bash

# Make sure to execute from the scripts directory
cd /data/0/scripts

# Global lists of PLAYERS and SERVERS
SERVER=$1
PLAYERS=whitelist.txt

# Loop through PLAYERS
while read -r player
do
  # Add players to ops lists
  #  echo "$instance - $player"
  screen -p 0 -S $SERVER -X eval "stuff \"whitelist add $player\"\015"
  sleep 1
done < $PLAYERS

