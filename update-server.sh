#!/bin/bash
#
# Script to update a minecraft world
#

# Start by checking for the correct number of parameters
USAGE="Usage: $0 <server_type> <server_name> <gamemode>"
if [ $# -lt 3 ]; then
  echo "Invalid number of arguments given"
  echo "$USAGE"
  echo ""
  exit 1;
fi
  
# Set all script variables
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )
SERVER_TYPE=$1
SERVER_NAME=$2
GAME_MODE=$3

# Make sure SERVER_TYPE is valid
if [ $SERVER_TYPE != "snapshot" || $SERVER_TYPE != "release" ]; then
  echo "Invalid server type given"
  echo "$USAGE"
  echo ""
  exit 1;
fi

# Makeu sure gamemode is valid
if [ $GAME_MODE != "survival" || $GAME_MODE != "creative" || $GAME_MODE != "adventure" ]; then
  echo "Inavlid gamemode"
  echo "$USAGE"
  echo ""
  exit 1;
fi

if [ -e "$BASE_DIR/$SERVER_NAME/current_server" ]; then
  CURRENT_SERVER=$( cat "$BASE_DIR/$SERVER_NAME/current_server" )
else
  CURRENT_SERVER="unknown"
fi

# If the server download detects a different version from what is running, do the following:
#  The download script brings in the new server jar file and erases the previous one
$SCRIPTS_DIR/get-server.sh $SERVER_TYPE $SERVER_NAME
NEW_SERVER=$( cat "$BASE_DIR/$SERVER_NAME/current_server" )

if [ ! "$CURRENT_SERVER" == "$NEW_SERVER" ]; then

  # Stop the current running world
  $SCRIPTS_DIR/stop.sh $SERVER_NAME

  # Back up the current world
  $SCRIPTS_DIR/backup-server.sh $SERVER_NAME

  # Create the launch script using the latest release
  #   Remove the current launch script first
  if [ -e "$BASE_DIR/$SERVER_NAME/launch.sh" ]; then
    rm "$BASE_DIR/$SERVER_NAME/launch.sh"
  fi
    
  # Create new launch.sh file
  echo "#!/bin/bash" >> "$BASE_DIR/$SERVER_NAME/launch.sh"
  echo "$BASE_DIR/java/bin/java -server -Xmx3096M -Xms3096M -jar minecraft_server.$NEW_SERVER.jar" >> "$BASE_DIR/$SERVER_NAME/launch.sh"
  chmod +x "$BASE_DIR/$SERVER_NAME/launch.sh"

  # Updating the server name with version running
  sed -i "s|motd=.*|motd=JC's $NEW_SERVER $SERVER_TYPE $GAME_MODE server|g" "$BASE_DIR/$SERVER_NAME/server.properties"
  sed -i "s|gamemode=.*|gamemode=$GAME_MODE|g" "$BASE_DIR/$SERVER_NAME/server.properties"

  # Start the world back up using the new version
  $SCRIPTS_DIR/start.sh $SERVER_NAME
else
  echo "Server version has not changed. Nothing to do."
fi
