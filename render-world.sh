#!/bin/bash
# This script will allow you to render out the world into web readable chunks

# Display Useage
USAGE="Usage: $0 <server-name>"
if [ $# -lt 1 ]; then
  echo "Invalid number of arguments given"
  echo "$USAGE"
  echo ""
  exit 1
fi

# Accept the following arguments
WEB_DIR=$1

# Change to the BlueMap web server directory
cd /data/1/$WEB_DIR

/data/1/java/bin/java -jar map.jar -r

