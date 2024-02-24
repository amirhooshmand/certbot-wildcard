# SSL Certificate Automation Script

This script is designed to help you obtain a free wildcard SSL certificate from Let's Encrypt using Certbot. It is specifically tested on Ubuntu 18.04 and 20.04, but with some modifications, it can be used on other operating systems as well.

## Prerequisites
- Ubuntu 18.04 or 20.04
- Certbot installed

## Installation
Run the script and follow the assistant:
```
wget https://raw.githubusercontent.com/amirhooshmand/certbot-wildcard/main/get-cert.sh&&chmod +x get-cert.sh&&./get-cert.sh
```

## Usage

1. Run the script:
   ```
   ./script.sh
   ```

2. Follow the instructions provided by the script.

   - You will be prompted to enter the domain for which you want to obtain the SSL certificate. This can be your main domain (e.g., example.com) or a wildcard domain (e.g., *.example.com).
   - The script will suggest a default email address, but you can enter a different email if desired.
   - Select the cloud provider by choosing the appropriate option:
     - 1 for [Cloudflare](https://www.cloudflare.com/)
     - 2 for [ArvanCloud](https://www.arvancloud.com/)
   - Depending on your choice, you will be prompted to enter the necessary API key and zone ID.

3. The script will download the required files for the authentication and cleanup hooks from the repository.

4. The script will use Certbot to obtain the SSL certificate using the provided information and configure it for the specified domain and any subdomains.


## Using Configuration File
Instead of providing input interactively, you can use a configuration file named `.creds` placed in the same directory as the script. The configuration file should have the following format:

```plaintext
DOMAIN="yourdomain.com"
CONTACT="your-email@example.com"
CLOUD="cloud-provider"
API_KEY="your-api-key"
ZONE_ID="your-zone-id"
```

Replace the values with your actual domain, email address, cloud provider, API key, and zone ID. When the script is executed, it will automatically read the configuration from the `.creds` file if it exists, eliminating the need for manual input.

## Important Notes
- Ensure that you have appropriate permissions to install packages and modify system configurations.
- The script supports two cloud providers: Cloudflare and ArvanCloud. If using the configuration file, make sure to set the `CLOUD` variable accordingly.
- If using the configuration file, the script will not prompt for domain and contact information as they will be read from the file.
- The script will download authentication and cleanup hook scripts from a GitHub repository. These scripts facilitate the DNS challenge required by Let's Encrypt. Make sure you have an internet connection during the script execution.

## Disclaimer

- This script is provided as-is without any warranty. Use it at your own risk.
- Make sure to review and understand the script before running it on your system.
- The script relies on external dependencies and assumes certain configurations. Modify it as needed to fit your specific environment.

## Contributing
Contributions are welcome! If you find any bugs or have suggestions for improvements, please create a pull request on the GitHub repository.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).