# !/bin/bash
# Script that gets the weekly snapshot minecraft server

# Make sure that the user passes in the correct number of parameters
if [ $# -lt 2 ]; then
    echo "Usage: $0 <release/snapshot> <server_name>"
    exit 1;
fi

# Set variables for the script to use
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )
SERVER_TYPE=$1
SERVER_NAME=$2

# Use the server type to download the correct version of the server
case $SERVER_TYPE in
    "release")
        echo "fetching latest release"
        SERVER_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json|jq -r ".latest|.release"`
        SERVER_JSON=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json|jq -r '.versions[]|select(.id=="'"$SERVER_VERSION"'")|.url'`
        SERVER_DOWNLOAD=`curl $SERVER_JSON | jq -r '.downloads|.server|.url'`
	;;
    "snapshot")
	echo "fetching latest snapshot"
	SERVER_VERSION=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json|jq -r ".latest|.snapshot"`
	SERVER_JSON=`curl https://launchermeta.mojang.com/mc/game/version_manifest.json|jq -r '.versions[]|select(.id=="'"$SERVER_VERSION"'")|.url'`
	SERVER_DOWNLOAD=`curl $SERVER_JSON | jq -r '.downloads|.server|.url'`
	;;
    *)
	echo "cannot determine server type: $SERVER_TYPE"
	;;
esac

# Set additional variables needed for later in the script for logging
TODAY="$(date +"%b %d, %Y") ($(date +"%H:%M:%S"))"
TARGETDIR=$BASE_DIR/$SERVER_NAME
if [ -e "$TARGETDIR" ]; then
    LOGFILE="$TARGETDIR/server-download.log"
    # Make sure that the file exists
    if [ -e "$TARGETDIR/current_server" ]; then
      CURRENT_SERVER=$( cat "$TARGETDIR/current_server" )
    else
      $( touch "$TARGETDIR/current_server" )
    fi

    # Look to see if the latest release has already been downloaded
    if [ "$CURRENT_SERVER" != "$SERVER_VERSION" ]; then
        cd $TARGETDIR
        wget -q $SERVER_DOWNLOAD --output-document="minecraft_server.${SERVER_VERSION}.jar"
        echo "$TODAY - ${SERVER_TYPE} ${SERVER_VERSION} was downloaded successfully" >> $LOGFILE
        
	# Check to see if the old server jar exists and delete it
        if [ -e "$TARGETDIR/minecraft_server.${CURRENT_SERVER}.jar" ]; then
            rm "$TARGETDIR/minecraft_server.${CURRENT_SERVER}.jar"
        fi
        echo $SERVER_VERSION > $TARGETDIR/current_server
    else
        echo "Latest server matches current version"
    fi
fi
