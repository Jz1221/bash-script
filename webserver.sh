#!/bin/bash

TITLE="Client Server System Deployment"
echo "$TITLE"
echo "--------------------------------------------"

SHARE_DIR="/srv/share"

# =========================
# APACHE SETUP
# =========================
echo "[1] Checking Apache..."

if ! rpm -q httpd &> /dev/null
then
    echo "Installing Apache..."
    sudo dnf install httpd -y
else
    echo "Apache already installed"
fi

sudo systemctl enable httpd
sudo systemctl start httpd

echo "Creating Web Page..."
echo "<h1>Client Server Web System Running</h1>" | sudo tee /var/www/html/test.html

# Firewall HTTP
if ! firewall-cmd --list-services | grep -q http
then
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --reload
fi

# =========================
# SAMBA SETUP
# =========================
echo "[2] Checking Samba..."

if ! rpm -q samba &> /dev/null
then
    echo "Installing Samba..."
    sudo dnf install samba samba-client samba-common -y
else
    echo "Samba already installed"
fi

# Shared folder
if [ ! -d "$SHARE_DIR" ]
then
    sudo mkdir -p $SHARE_DIR
fi

sudo chmod -R 777 $SHARE_DIR

echo "Hello World from Samba Share" | sudo tee $SHARE_DIR/index.txt

# Samba config
if ! grep -q "MyShare" /etc/samba/smb.conf
then
    echo "Configuring Samba share..."

    sudo bash -c "cat >> /etc/samba/smb.conf <<EOF

[MyShare]
   path = /srv/share
   browsable = yes
   writable = yes
   read only = no
   guest ok = no
   valid users = student
EOF"
fi

# Firewall Samba
if ! firewall-cmd --list-services | grep -q samba
then
    sudo firewall-cmd --permanent --add-service=samba
    sudo firewall-cmd --reload
fi

# Start services
sudo systemctl enable smb
sudo systemctl start smb

echo "SETUP COMPLETE"
echo "Web Server  : http://<server-ip>"
echo "File Share  : smb://<server-ip>/MyShare"

# =========================
# MENU SYSTEM
# =========================
while true
do
    echo ""
    echo "=============================="
    echo " CONTROL PANEL (Web + Samba)"
    echo "=============================="
    echo "1. Start Apache"
    echo "2. Stop Apache"
    echo "3. Status Apache"
    echo ""
    echo "4. Start Samba"
    echo "5. Stop Samba"
    echo "6. Status Samba"
    echo ""
    echo "7. Restart Both"
    echo "8. Exit"
    echo "=============================="

    read -p "Enter choice: " choice

    echo ""

    case $choice in

    1) sudo systemctl start httpd ;;
    2) sudo systemctl stop httpd ;;
    3) sudo systemctl status httpd --no-pager ;;

    4) sudo systemctl start smb ;;
    5) sudo systemctl stop smb ;;
    6) sudo systemctl status smb --no-pager ;;

    7)
        sudo systemctl restart httpd
        sudo systemctl restart smb
        echo "Both services restarted"
        ;;

    8)
        echo "Exiting..."
        break
        ;;

    *)
        echo "Invalid option"
        ;;
    esac
done