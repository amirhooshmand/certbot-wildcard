#!/bin/bash

# Get the path of the script's directory
REPO_PATH=$(dirname "$(readlink -f "$0")")

# Read the API key and zone ID from the creds file
API_KEY=$(grep API_KEY "$REPO_PATH/$CERTBOT_DOMAIN/cf.creds" | cut -d '"' -f 2)
ZONE_ID=$(grep ZONE_ID "$REPO_PATH/$CERTBOT_DOMAIN/cf.creds" | cut -d '"' -f 2)

# Create the domain for ACME challenge
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"

# Create a DNS record using the Cloudflare API
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","content":"'"$CERTBOT_VALIDATION"'","ttl":120}'

# Retrieve the ID of the created DNS record
RECORD_ID=$(curl -s "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=TXT&name=$CREATE_DOMAIN" \
    -H "Content-Type:application/json" \
    -H "Authorization: Bearer $API_KEY" |
    grep -oE "\"id\":\"\w+\"" |
    cut -d '"' -f 4)

# Create a directory for storing temporary files if it doesn't exist
if [ ! -d "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT" ]; then
    mkdir -pm 0700 "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT"
fi

# Write the zone ID and record ID to temporary files
echo "$ZONE_ID" >"$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/ZONE_ID"
echo "$RECORD_ID" >"$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/RECORD_ID"

# Wait for 15 seconds - this is the time it takes for the DNS record to be updated
sleep 15
