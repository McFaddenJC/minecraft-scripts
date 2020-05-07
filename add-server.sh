#!/bin/bash
#
# Add server to the list of servers to start/stop

# Make sure the server was passed into the script
if [ $# -lt 1 ]; then
  echo ""
  echo "Usage: $0 <server_name>"
  echo ""
  exit 1
else
  # Set all script variables
  SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  SERVER=$1
  FILE=$SCRIPTS_DIR/server-list.txt

  # Loop through all servers to make sure it isn't in the list already
  while read -r file_entry
  do
    if [ $SERVER == $file_entry ]; then
      echo "$SERVER already exists. Skipping."
      exit 0
    fi
  done < "$FILE"

  echo "Adding $SERVER to server list"
  echo $SERVER >> $FILE
fi
