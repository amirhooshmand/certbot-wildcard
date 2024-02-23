#!/bin/bash

REPO_PATH=$(dirname "$(readlink -f "$0")")
API_KEY=$(grep API_KEY "$REPO_PATH/$CERTBOT_DOMAIN/arvan.creds" | cut -d '"' -f 2)

if [ -f "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/RECORD_ID" ]; then
    RECORD_IDS=$(cat "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/RECORD_ID")
    rm -f "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/RECORD_ID"
fi

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_IDS}" ]; then
    for RECORD_ID in $RECORD_IDS
    do curl -s -X DELETE "https://napi.arvancloud.ir/cdn/4.0/domains/$CERTBOT_DOMAIN/dns-records/$RECORD_ID" \
            -H "Authorization: $API_KEY" \
            -H "Content-Type: application/json"
    done
fi