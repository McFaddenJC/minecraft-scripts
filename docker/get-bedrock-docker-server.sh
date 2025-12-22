# !/bin/bash
# Script that gets the latest minecraft server

# Make sure that the user passes in the correct number of parameters
if [ $# -lt 1 ]; then
  echo "Usage: $0 <server_name>"
  exit 1;
fi

# Set variables for the script to use
SCRIPTS_DIR=/path to where this script is/
BASE_DIR=/path to where your servers are/
SERVER_NAME=$1

# Use the server type to download the correct version of the server
echo "fetching release"
DELIMITER="/"
LATEST_VERSION=$(curl -s 'https://net-secondary.web.minecraft-services.net/api/v1.0/download/links')
LATEST_VERSION=$(echo $LATEST_VERSION | jq -r '.result.links[] | select(.downloadType=="serverBedrockLinux") | .downloadUrl')
LATEST_VERSION=$(echo $LATEST_VERSION | awk -F"$DELIMITER" '{print $6}')

# Set additional variables needed for later in the script for logging
TARGETDIR=$BASE_DIR/$SERVER_NAME
if [ -e "$TARGETDIR" ]; then
  # Make sure that the file exists
  if [ -e "$TARGETDIR/current_server" ]; then
    CURRENT_SERVER=$( cat "$TARGETDIR/current_server" )
  else
    $( touch "$TARGETDIR/current_server" )
  fi

  # Look to see if the latest release has already been downloaded
  if [ "$CURRENT_SERVER" != "$LATEST_VERSION" ]; then
    cd $TARGETDIR
    # Check to see if the old server jar exists and delete it
      echo $LATEST_VERSION > $TARGETDIR/current_server
  else
    echo "Latest server matches current version"
  fi
fi
