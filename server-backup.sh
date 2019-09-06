#!/bin/bash
#
#  Script to backup minecraft worlds twice daily
#

TODAY=$(date +"%Y%m%d_%k")
SERVERS=server-list.txt
CDIR=`pwd`

# Loop through the servers to perform the save and backup
while read -r SERVER
do
  screen -p 0 -S $SERVER -X eval "stuff \"say Server is auto saving and may become a bit laggy during the process\"\015"
  screen -p 0 -S $SERVER -X eval "stuff \"save-off\"\015"
  screen -p 0 -S $SERVER -X eval "stuff \"say Turned off world auto-saving\"\015"
  screen -p 0 -S $SERVER -X eval "stuff \"save-all\"\015"
  screen -p 0 -S $SERVER -X eval "stuff \"say Saved the world\"\015"
  `cd /data/0/$SERVER`
  `cp world -R world-bak`
  `tar -cvzf $TODAY-$SERVER.tar.gz world-bak`
  `rm world-bak -rf`
  `cd $CDIR`
  screen -p 0 -S $SERVER -X eval "stuff \"save-on\"\015"
  screen -p 0 -S $SERVER -X eval "stuff \"say Turned on world auto-saving\"\015"
done < "$SERVERS"

