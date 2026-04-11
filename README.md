# Client Server System Deployment

This Bash script automates the deployment of a client-server web system using Apache HTTP Server and Samba file sharing on a Linux system (tested with Fedora/RHEL-based distributions using `dnf`).

## Features

- **Apache Web Server Setup**: Installs and configures Apache, creates a test web page, and opens HTTP port in the firewall.
- **Samba File Sharing**: Installs and configures Samba, creates a shared directory, and sets up a guest-accessible share.
- **Interactive Control Panel**: Provides a menu-driven interface to start, stop, restart, and check the status of Apache and Samba services.

## Requirements
Client VM - Ubuntu
Server VM - ORacle Linux

## Prerequisites

- Linux distribution with `dnf` package manager (e.g., Fedora, CentOS, RHEL).
- Root or sudo privileges.
- Internet connection for package installation.
- Firewall enabled (firewalld service).

## Usage

1. **Download the script**: Save `webserver.sh` to your server.

2. **Make it executable**:
   ```bash
   chmod +x webserver.sh
   ```

3. **Run the script**:
   ```bash
   sudo ./webserver.sh
   ```

   The script will:
   - Check and install Apache if not present.
   - Enable and start Apache service.
   - Create a test HTML page at `/var/www/html/test.html`.
   - Configure firewall to allow HTTP traffic.
   - Check and install Samba if not present.
   - Create shared directory `/srv/share` with a test file.
   - Configure Samba share "MyShare" (accessible by user "student" which need to create username student and password).
   - Configure firewall to allow Samba traffic.
   - Start Samba service.

4. **Access the services**:
   - **Web Server**: Open `http://<server-ip>/test.html` in a browser.
   - **File Share**: Access `smb://<server-ip>/MyShare` from a client (requires Samba client and valid credentials).

5. **Control Panel**: After initial setup, the script enters an interactive menu:
   - 1-3: Control Apache (start, stop, status)
   - 4-6: Control Samba (start, stop, status)
   - 7: Restart both services
   - 8: Exit the script

## Configuration Details

- **Apache**: Default configuration with test page at `/var/www/html/test.html`.
- **Samba**: Share configured for user "student" (you may need to create this user and set a password with `smbpasswd -a student`).
- **Firewall**: Services added permanently to firewalld.
- **Shared Directory**: `/srv/share` with 777 permissions (world-writable).

## Security Notes

- The Samba share is configured without guest access (`guest ok = no`), requiring authentication.
- Shared directory has broad permissions (777) - adjust as needed for security.
- Ensure the "student" user exists and has Samba password set before accessing the share.

## Troubleshooting

- If services fail to start, check system logs with `journalctl -u httpd` or `journalctl -u smb`.
- Firewall issues: Verify firewalld is running and rules are applied.
- Samba access issues: Ensure user credentials are correct and firewall allows Samba ports.

## Requirements

- Bash shell
- sudo access
- dnf package manager
- systemctl for service management
- firewall-cmd for firewall configuration