#!/bin/bash
# Script that gets the latest minecraft client

# Make sure that the user passes in the correct number of parameters
if [ $# -lt 1 ]; then
  echo "Usage: $0 <release/snapshot> [version]"
  exit 1;
fi

# Set variables for the script to use
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )
CLIENT_TYPE=$1
CLIENT_NAME=$2
CLIENT_VERSION=$3
CLIENT_MANIFEST=$( curl https://launchermeta.mojang.com/mc/game/version_manifest.json )

# Use the client type to download the correct version of the client
case $CLIENT_TYPE in
  "release")
    echo "fetching release"
    if [ -z "$CLIENT_VERSION" ]; then
      CLIENT_VERSION=$( echo $CLIENT_MANIFEST|jq -r ".latest|.release" )
    fi
    CLIENT_JSON=$( echo $CLIENT_MANIFEST|jq -r '.versions[]|select(.id=="'"$CLIENT_VERSION"'")|.url' )
    CLIENT_DOWNLOAD=$( curl $CLIENT_JSON | jq -r '.downloads|.client|.url' )
  ;;
  "snapshot")
    echo "fetching snapshot"
    if [ -z "$CLIENT_VERSION" ]; then
      CLIENT_VERSION=$( echo $CLIENT_MANIFEST|jq -r ".latest|.snapshot" )
    fi
    CLIENT_JSON=$( echo $CLIENT_MANIFEST|jq -r '.versions[]|select(.id=="'"$CLIENT_VERSION"'")|.url' )
    CLIENT_DOWNLOAD=$( curl $CLIENT_JSON | jq -r '.downloads|.client|.url' )
  ;;
  *)
    echo "cannot determine client type: $CLIENT_TYPE"
    exit 1
  ;;
esac

# If the client version matches a download then download that client
wget -q $CLIENT_DOWNLOAD --output-document="minecraft_client.${CLIENT_VERSION}.jar"
