#!/bin/bash

# Read the list of snapshot servers
SERVER_FILE=snapshot_servers.txt

# Loop through the server names and start them up here
while read -r line
do
  server=$line
  checkServer $server
done < "$SERVER_FILE"

# See if there is already a server by that name
#  If there is, continue
#  If there is not, create a server there
if [ -e "/data/0/$SERVER" ]; then

fi

# Compare the latest snapshot version to the one running
#  If they match, do nothing
#  If they do not match, continue

# Download the latest snapshot to the right place

# 
