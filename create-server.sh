#!/bin/bash

# Get server type and location
USAGE="Usage: $0 <release/snapshot> <server_name> <port#> <gamemode> [version]"
if [ $# -lt 4 ]; then
  echo "Invalid number of arguments given"
  echo "$USAGE"
  echo ""
  exit 1
fi

# Set any environment variables here
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )
SERVER_TYPE=$1
SERVER_NAME=$2
SERVER_PORT=$3
GAME_MODE=$4
SERVER_VERSION=$5
DIFFICULTY="normal" # Set what difficulty you wish to play in
PVP="true" # Set whether or not you wish to allow pvp on the server
MAX_PLAYERS="10" # Set the number of players you want to cap the server at
JAVA_MEM="5" # Memory in GB that you wish to alot to the JVM to run the server
# You can change MOTD to be any name prefix you want displayed from the server
#   status page in the game's client under multiplayer
MOTD="JC's"

# Make sure SERVER_TYPE is valid
if [ $SERVER_TYPE != "snapshot" || $SERVER_TYPE != "release" ]; then
  echo "Invalid server type given"
  echo "$USAGE"
  echo ""
  exit 1
fi

# Make sure the game mode is valid
if [ $GAME_MODE != "survival" || $GAME_MODE != "adventure" || $GAME_MODE != "creative" ]; then
  echo "Invalid game mode!"
  echo "$USAGE"
  echo ""
  exit 1
fi

# Add server to the list of servers to start/stop
$SCRIPTS_DIR/add-server.sh $SERVER_NAME

# Check to see if the folder/directory exists
if [ -e "$BASE_DIR/$SERVER_NAME" ]; then
  echo "The server exists"
  # Copy in the server icon to make sure it's up to date
  echo "Copying server-icon to server"
  cp $SCRIPTS_DIR/server-icon.png $BASE_DIR/$SERVER_NAME
  echo "Downloading $SERVER_TYPE server"
  if [ -z "$SERVER_VERSION" ]; then
    $SCRIPTS_DIR/get-server.sh $SERVER_TYPE $SERVER_NAME
  else
    $SCRIPTS_DIR/get-server.sh $SERVER_TYPE $SERVER_NAME $SERVER_VERSION
  fi
else
  echo "The server does not exist yet"
  # Create the directory and copy in the server icon
  echo "Creating server structure"
  mkdir -p "$BASE_DIR/$SERVER_NAME"
  echo "Copying server-icon to server"
  cp "$SCRIPTS_DIR/server-icon.png" "$BASE_DIR/$SERVER_NAME"

  # Download the release/snapshot to the server structure
  echo "Downloading $SERVER_TYPE server"
  if [ -z "$SERVER_VERSION" ]; then
    $SCRIPTS_DIR/get-server.sh $SERVER_TYPE $SERVER_NAME
  else
    $SCRIPTS_DIR/get-server.sh $SERVER_TYPE $SERVER_NAME $SERVER_VERSION
  fi

  # Start the new server to generate configuration files
  echo "Navigating to the new server"
  cd "$BASE_DIR/$SERVER_NAME"

  # Get the latest version
  CURRENT_SERVER=$( cat "$BASE_DIR/$SERVER_NAME/current_server" )

  # Create the launch script
  #   Remove the current launch script first
  if [ -e "$BASE_DIR/$SERVER_NAME/launch.sh" ]; then
    rm "$BASE_DIR/$SERVER_NAME/launch.sh"
  fi

  # Create new launch.sh file
  echo "#!/bin/bash" >> "$BASE_DIR/$SERVER_NAME/launch.sh"
  echo "/data/1/java/bin/java -server -Xmx${JAVA_MEM}G -Xms${JAVA_MEM}G -jar minecraft_server.$CURRENT_SERVER.jar nogui" >> "$BASE_DIR/$SERVER_NAME/launch.sh"
  chmod +x "$BASE_DIR/$SERVER_NAME/launch.sh"

  if [ ! -e "$BASE_DIR/$SERVER_NAME/eula.txt" ]; then
    echo "Starting server to generate config files"
    $BASE_DIR/$SERVER_NAME/launch.sh

    # Set config file properties via user prompt
    sed -i "s/eula=.*/eula=true/g" "$BASE_DIR/$SERVER_NAME/eula.txt" # Needs to be set to true to allow server to start
    sed -i "s/difficulty=.*/difficulty=$DIFFICULTY/g" "$BASE_DIR/$SERVER_NAME/server.properties"
    sed -i "s/gamemode=.*/gamemode=$GAME_MODE/g" "$BASE_DIR/$SERVER_NAME/server.properties"
    sed -i "s/pvp=.*/pvp=$PVP/g" "$BASE_DIR/$SERVER_NAME/server.properties"
    sed -i "s/server-port=.*/server-port=$SERVER_PORT/g" "$BASE_DIR/$SERVER_NAME/server.properties"
    sed -i "s/max-players=.*/max-players=$MAX_PLAYERS/g" "$BASE_DIR/$SERVER_NAME/server.properties"
    sed -i "s/motd=.*/motd=$MOTD $CURRENT_SERVER $SERVER_TYPE $GAME_MODE Server/g" "$BASE_DIR/$SERVER_NAME/server.properties"

    # Start server with necessary property file updates
    $SCRIPTS_DIR/all-start.sh
  else
    echo "Server already configured"
  fi
fi
