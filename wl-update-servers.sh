#!/bin/bash

# Make sure to execute from the scripts directory
cd /data/0/scripts

# Global lists of PLAYERS and SERVERS
PLAYERS=whitelist.txt

# Loop through PLAYERS
while read -r player
do
  # Add players to ops lists
  #  echo "$instance - $player"
  ./wl-add-player.sh $player
done < $PLAYERS

