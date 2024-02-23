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


## Disclaimer

- This script is provided as-is without any warranty. Use it at your own risk.
- Make sure to review and understand the script before running it on your system.
- The script relies on external dependencies and assumes certain configurations. Modify it as needed to fit your specific environment.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).