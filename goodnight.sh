#!/bin/bash
if [ $# -lt 1 ]; then
  echo ""
  echo "You must specify a server!"
  echo "Usage: $0 <server_name>"
  echo ""
  exit 1
fi

# Set variables to be used throughout script
SERVER_NAME=$1

# Set the root dir where the scripts are located
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get the number of lines in the goodnight messages file
LINE_COUNT=$( wc -l $SCRIPTS_DIR/goodnight-messages.txt )

# Turn the LCOUNT into just the number
INDEX=$( echo $LINE_COUNT | awk '{print $1;}' )

# Get the random value based on the INDEX
RINDEX==$(( ( RANDOM % $INDEX ) + 1 ))

# Fetch the random message based on the random index
MESSAGE=$( sed "${RINDEX}q;d" $SCRIPTS_DIR/goodnight-messages.txt )

# Output message to the server selected
screen -p 0 -S $SERVER_NAME -X eval "stuff \"say $MESSAGE\"\015"
screnn -p 0 -S $SERVER_NAME -X eval "stuff \"say The server will shut down in five minutes.\"\015"