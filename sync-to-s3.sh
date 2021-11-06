#!/bin/bash

# Make sure the user passed in the bucket name and the server name
USAGE="${0} <s3 bucket name> <minecraft world name>"
if [ $# -lt 2 ]; then
    echo ""
    echo "Wrong number of arguments given"
    echo "${USAGE}"
    echo ""
    exit 1
fi

# Set scripts folder
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$( sed 's|/minecraft-scripts||g' <<< $SCRIPTS_DIR )

# Set variables to be used
S3_BUCKET=$1
SERVER_NAME=$2

# Copy the contents of that server up to S3
aws s3 sync ${BASE_DIR}/${SERVER_NAME} s3://${S3_BUCKET}/${SERVER_NAME}/ --exact-timestamps
