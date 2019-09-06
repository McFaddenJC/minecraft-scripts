#!/bin/bash
#
#  Script to get the current PID and reference it to restart
#

MC_PID=`ps -ef|grep java|grep -v grep|awk '{print $2}'`
SERVER_DIR=/data/0/mc25001
SERVER_SCREEN=mc25001


if [ -z "${MC_PID}" ];
then
  echo "The server needs to be restarted"
  echo "Starting mc25001"
  screen -S ${SERVER_SCREEN} -p 0 -X quit
  sleep 2
  cd ${SERVER_DIR}
  screen -dmS ${SERVER_SCREEN}
  sleep 2
  screen -p 0 -S ${SERVER_SCREEN} -X eval "stuff \"./launch.sh\"\015"
else
  echo "The PID exists; Server is running"
fi
