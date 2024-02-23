#!/bin/bash

REPO_PATH=$(dirname "$(readlink -f "$0")")
API_KEY=$(grep API_KEY "$REPO_PATH/$CERTBOT_DOMAIN/cf.creds" | cut -d '"' -f 2)

if [ -f "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/ZONE_ID" ]; then
    ZONE_ID=$(cat "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/ZONE_ID")
    rm -f "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/ZONE_ID"
fi

if [ -f "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/RECORD_ID" ]; then
    RECORD_IDS=$(cat "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/RECORD_ID")
    rm -f "$REPO_PATH/$CERTBOT_DOMAIN/CERTBOT/RECORD_ID"
fi

# Remove the challenge TXT record from the zone
if [ -n "${ZONE_ID}" ]; then
    if [ -n "${RECORD_IDS}" ]; then
        for RECORD_ID in $RECORD_IDS; do
            curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
                -H "Authorization: Bearer $API_KEY" \
                -H "Content-Type: application/json"
        done
    fi
fi
