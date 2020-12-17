#!/bin/bash

# Get list of all the servers from file
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE=$SCRIPTS_DIR/server-list.txt

# Loop through the server names and start them up here
while read -r line
do
  server=$line
  $SCRIPTS_DIR/stop.sh $server &
done < "$FILE"

${SCRIPTS_DIR}/stop-web.sh

echo ""
echo "All servers sent the shutdown signal..."
echo ""

