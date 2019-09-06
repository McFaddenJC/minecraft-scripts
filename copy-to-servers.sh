#!/bin/bash

# Get list of all the servers from file
FILE=server-list.txt

# Loop through the server names and start them up here
while read -r line
do
  server=$line
  cp $1 /opt/0/$server
done < "$FILE"

echo ""
echo "The file: $1, has been copied to all servers!"
echo ""
