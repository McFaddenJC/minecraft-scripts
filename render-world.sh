#!/bin/bash
# This script will allow you to render out the world into web readable chunks

SERVER=$1

cd /data/1/$SERVER

/data/1/java/bin/java -jar BlueMap-1.3.0-snap-cli.jar -r

