#!/bin/bash

echo "This script will help you to obtain a free SSL certificate from Let's Encrypt and apply it to Nginx."
echo "This script is tested on Ubuntu 18.04 and 20.04."
echo "If you are using a different OS, you may need to modify the script."
read -p "Press Enter to continue or Ctrl+C to exit." tmp

# Check if Certbot is installed
if command -v certbot &>/dev/null; then
    echo "Certbot is already installed."
    certbot --version
else
    echo "Certbot is not installed. Installing..."
    sudo apt update
    sudo apt install certbot python3-certbot-apache -y
fi

REPO_PATH=$(dirname "$(readlink -f "$0")")
HOOK_DRECTORY="$REPO_PATH/manual_hooks"

# Prompt the user to enter the domain
read -p "Enter the domain: " DOMAIN_NAME

# Suggest a default email address
DEFAULT_EMAIL="info@$DOMAIN_NAME"

# Prompt the user to enter the email
read -p "Enter the email [$DEFAULT_EMAIL]: " CONTACT

# Prompt the user to select the cloud provider
echo "Select the cloud provider:"
echo "1. Cloudflare"
echo "2. ArvanCloud"

mkdir -p "$HOOK_DRECTORY/$DOMAIN_NAME"

while true; do
    read -p "Enter your choice (1 or 2): " CLOUD_CHOICE
    case $CLOUD_CHOICE in
    1)
        CLOUD="cf"

        # Prompt the API key and zone ID
        read -p "Enter your Cloudflare API key: " API_KEY
        read -p "Enter your Cloudflare zone ID: " ZONE_ID

        # Save the API key and zone ID to the creds file
        echo "API_KEY=\"$API_KEY\"" >"$HOOK_DRECTORY/$DOMAIN_NAME/$CLOUD.creds"
        echo "ZONE_ID=\"$ZONE_ID\"" >>"$HOOK_DRECTORY/$DOMAIN_NAME/$CLOUD.creds"

        break
        ;;
    2)
        CLOUD="arvan"

        # Prompt the API key
        read -p "Enter your ArvanCloud API key: " API_KEY

        # Save the API key to the creds file
        echo "API_KEY=\"$API_KEY\"" >"$HOOK_DRECTORY/$DOMAIN_NAME/$CLOUD.creds"

        break
        ;;
    *)
        echo "Invalid choice. Please enter 1 or 2."
        ;;
    esac
done

# Use the default email if no input provided
CONTACT="${CONTACT:-$DEFAULT_EMAIL}"

MANUAL_HOOKS_BASE_URL="https://raw.githubusercontent.com/amirhooshmand/cloud-certbot/main/manual_hooks"

download_file() {
    file_url=$1
    destination_folder=$2

    # Extract the filename from the URL
    filename=$(basename "$file_url")

    # Set the destination path
    destination_path="$destination_folder/$filename"

    # Download the file using curl
    curl -o "$destination_path" "$file_url"

    # Check if the download was successful
    if [ $? -ne 0 ]; then
        echo "Failed to download the file: $file_url"
    else
        chmod +x "$destination_path"
    fi
}

auth_url="$MANUAL_HOOKS_BASE_URL/$CLOUD.auth.sh"
clean_url="$MANUAL_HOOKS_BASE_URL/$CLOUD.clean.sh"

mkdir -p $HOOK_DRECTORY
download_file "$auth_url" "$HOOK_DRECTORY"
download_file "$clean_url" "$HOOK_DRECTORY"

certbot certonly -n --agree-tos --manual \
    --no-eff-email --preferred-challenges=dns \
    --manual-auth-hook "$HOOK_DRECTORY"/$CLOUD.auth.sh \
    --manual-cleanup-hook "$HOOK_DRECTORY"/$CLOUD.clean.sh \
    -m "$CONTACT" -d "$DOMAIN_NAME",*."$DOMAIN_NAME"

rm -r "$HOOK_DRECTORY"
