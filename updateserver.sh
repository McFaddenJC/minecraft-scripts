#!/bin/bash

# Make sure they included the name of the current build.
if [ $1 =  ]; then
  echo "Please specify the upgrade file"
  exit 0;
fi

# Get list of all the servers from file
FILE=server-list.txt

# Loop through the server names and start them up here
while read -r line
do
  server=$line
  cp $1 /data/0/$server/minecraft_server.jar
done < "$FILE"

echo ""
echo "All servers have been updated"
echo ""
