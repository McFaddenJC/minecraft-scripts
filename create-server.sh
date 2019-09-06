#!/bin/bash

# Get server type and location
if [ $# -lt 3 ]; then
  echo ""
  echo "Usage: $0 <release/snapshot> <server_name> <port#>"
  echo ""
  exit 1;
else
  # Set any environment variables here
  SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  BASE_DIR=$( sed 's|/scripts||g' <<< $SCRIPTS_DIR )
  SERVER_TYPE=$1
  SERVER_NAME=$2
  SERVER_PORT=$3

  # Add server to the list of servers to start/stop
  $SCRIPTS_DIR/add-server.sh $SERVER_NAME 

  # Check to see if the folder/directory exists
  if [ -e "$BASE_DIR/$SERVER_NAME" ]; then
    echo "The server exists"
    # Copy in the server icon to make sure it's up to date
    echo "Copying server-icon to server"
    cp $SCRIPTS_DIR/server-icon.png $BASE_DIR/$SERVER_NAME
    echo "Downloading latest $SERVER_TYPE server"
    $SCRIPTS_DIR/get-server.sh $SERVER_TYPE $SERVER_NAME
  else
    echo "The server does not exist yet"
    # Create the directory and copy in the server icon
    echo "Creating server structure"
    mkdir -p "$BASE_DIR/$SERVER_NAME"
    echo "Copying server-icon to server"
    cp "$SCRIPTS_DIR/server-icon.png" "$BASE_DIR/$SERVER_NAME"

    # Download the latest release/snapshot to the server structure
    echo "Downloading latest $SERVER_TYPE server"
    $SCRIPTS_DIR/get-server.sh $SERVER_TYPE $SERVER_NAME

    # Start the new server to generate configuration files
    echo "Navigating to the new server"
    cd "$BASE_DIR/$SERVER_NAME"

    # Get the latest version
    CURRENT_SERVER=$( cat "$BASE_DIR/$SERVER_NAME/current_server" )
    
    # Create the launch script using the latest release
    #   Remove the current launch script first
    if [ -e "$BASE_DIR/$SERVER_NAME/launch.sh" ]; then
      rm "$BASE_DIR/$SERVER_NAME/launch.sh"
    fi
    
    # Create new launch.sh file
    echo "#!/bin/bash" >> "$BASE_DIR/$SERVER_NAME/launch.sh"
    echo "java -server -Xmx2048M -Xms2048M -jar minecraft_server.$CURRENT_SERVER.jar" >> "$BASE_DIR/$SERVER_NAME/launch.sh"
    chmod +x "$BASE_DIR/$SERVER_NAME/launch.sh"

    if [ ! -e "$BASE_DIR/$SERVER_NAME/eula.txt" ]; then
      echo "Starting server to generate config files"
      $BASE_DIR/$SERVER_NAME/launch.sh
      
      # Set config file properties via user prompt
      sed -i 's/eula=false/eula=true/g' "$BASE_DIR/$SERVER_NAME/eula.txt"
      sed -i 's/difficulty=easy/difficulty=normal/g' "$BASE_DIR/$SERVER_NAME/server.properties"
      sed -i 's/pvp=true/pvp=false/g' "$BASE_DIR/$SERVER_NAME/server.properties"
      sed -i "s/server-port=25565/server-port=$SERVER_PORT/g" "$BASE_DIR/$SERVER_NAME/server.properties"
      sed -i 's/max-players=20/max-players=10/g' "$BASE_DIR/$SERVER_NAME/server.properties"
      sed -i 's/motd=A Minecraft Server/motd=JC''s Minecraft Server/g' "$BASE_DIR/$SERVER_NAME/server.properties"

      # Copying in datapack
      $SCRIPTS_DIR/all-start.sh
      while [ ! -e "$BASE_DIR/$SERVER_NAME/world/datapacks" ]
      do
	sleep 2
      done
      $( cp ${BASE_DIR}/datapacks/* ${BASE_DIR}/${SERVER_NAME}/world/datapacks/ )
      sleep 2
      screen -p 0 -S ${SERVER_NAME} -X eval "stuff \"reload\"\015"
    else
      echo "Server already configured"
    fi
  fi
fi
