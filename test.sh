#!/bin/bash
#
#  Script called from a crontab to echo out the date to file every minute
#

#TSTAMP=$(date +"%H:%M:%S")

#echo $TSTAMP >> times.txt

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "SCRIPTS_DIR = $SCRIPTS_DIR"
#cd $DIR
#cd ..
#BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/scripts||g' <<< $SCRIPTS_DIR )
echo "BASE_DIR = $BASE_DIR"

$( cp ${SCRIPTS_DIR}/datapacks/* ${BASE_DIR}/testing/world/datapacks/ )
