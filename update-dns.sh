#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Incorrect number of arguments given!"
  echo "$0 <hosted zone id> <dns entry>"
  echo ""
  exit 1;
fi

# Set the base of the sripts directory
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

HOSTED_ZONE_ID=$1
DNS_ENTRY=$2

# Get the latest public IP that the router has
NEW_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Set the following value and comment out above to test changes
#NEW_IP="10.90.1.1"

# Get the current public IP set in DNS for any DNS entry in Route53
CURRENT_IP=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID | jq -r '.ResourceRecordSets[] | select(.Name=="'"$DNS_ENTRY"'.") | .ResourceRecords[].Value')

# Testing values. Remove comments to see output
#echo "My public IP is: $NEW_IP"
#echo "My DNS IP is: $CURRENT_IP"

# Compare the two IP's to see if a change needs to be made
if [ "$CURRENT_IP" != "$NEW_IP" ]; then
  # The IP address needs to be updated in the json file record set
  echo "The IP addresses are different and DNS needs to be updated"
  sed -i 's|"Value":.*|"Value": "'$NEW_IP'"|g' $SCRIPTS_DIR/$DNS_ENTRY.json

  # Update the DNS Record Set with the new IP
  aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://$SCRIPTS_DIR/$DNS_ENTRY.json 
else
  echo "The IP addresses are the same and no change is needed"
fi
