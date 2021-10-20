#!/bin/bash

# Server to apply this to (passed in as a variable)
SERVER=$1

# Command to list a player's inventory
# COMMAND="data get entity ${PlayerName} Inventory"

# See if the screen is active and only proceed if it is
if ! screen -list | grep -q "$SERVER"; then
    # Server is not running so don't look for inventory
    # echo "Server isn't running"
    exit 0;
else
    # Server is running so execute commands

    # Get list of the whitelisted players
    PlayerList=$( cat /data/1/${SERVER}/whitelist.json | grep name | awk '{print $2}' | sed "s|\"||" | sed "s|\"||" )

    # Loop through player list and execute the inventory command
    for PlayerName in $PlayerList
    do
        screen -p 0 -S $SERVER -X eval "stuff \"data get entity $PlayerName Inventory\"\015"
    done
fi
