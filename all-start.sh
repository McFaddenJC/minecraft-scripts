#!/bin/bash

# Get list of all the servers from file
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE=$SCRIPTS_DIR/server-list.txt

# Loop through the server names and start them up here
while read -r line
do
  server=$line
  $SCRIPTS_DIR/start.sh $server
done < "$FILE"

echo ""
echo "All servers have been started"
echo ""
