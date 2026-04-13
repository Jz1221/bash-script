#!/bin/bash

TITLE="Advanced Server Deployment & OS Context Audit System"
echo "$TITLE"
echo "--------------------------------------------"

# FILE DIRECTORY
SHARE_DIR="/srv/share/neuro_data"
STRESS_DIR="/tmp/bhi_signal_stress"

# 1. (Apache, Samba, Cockpit)
echo "[System] Initializing Services..."
sudo dnf install httpd samba samba-client samba-common cockpit -y &> /dev/null

sudo systemctl enable --now httpd
sudo systemctl enable --now smb
sudo systemctl enable --now cockpit.socket

sudo mkdir -p $SHARE_DIR
sudo chmod -R 777 $SHARE_DIR

# 防火墙配置
for svc in http samba cockpit; do
    if ! firewall-cmd --list-services | grep -q $svc; then
        sudo firewall-cmd --permanent --add-service=$svc &> /dev/null
    fi
done
sudo firewall-cmd --reload &> /dev/null

echo ">> Deployment Complete. Services are running."
echo ""

# MENU SYSTEM 
while true
do
    echo "=================================================="
    echo "  SERVER CONTROL PANEL & OS CONTEXT AUDIT"
    echo "=================================================="
    echo "--- Standard Services ---"
    echo "1. Restart All Services (Web, SMB, Cockpit)"
    echo "2. Check Services Status"
    echo ""
    echo "--- [Assignment] OS Context Simulation ---"
    echo "3. Run Context 1: Config Integrity Audit (ls -l)"
    echo "4. Run Context 2: Inode Pressure Stress Test (df -i)"
    echo ""
    echo "0. Exit"
    echo "=================================================="

    read -p "Enter choice [0-4]: " choice
    echo ""

    case $choice in
    1)
        sudo systemctl restart httpd smb cockpit.socket
        echo "[OK] All services restarted."
        ;;
    2)
        echo "--- Apache ---"; systemctl is-active httpd
        echo "--- Samba ---"; systemctl is-active smb
        echo "--- Cockpit ---"; systemctl is-active cockpit.socket
        ;;
    
    # Assignment Context 1: Config Integrity
    3)
        echo ">> EXECUTING OS CONTEXT 1: Config Integrity <<"
        echo "[*] Task Category: Config Integrity"
        echo "[*] OS Stress Condition: Normal"
        echo "[*] Resource Constraint: None"
        
        TARGET_FILE="/etc/samba/smb.conf"
        
        # Trigger Condition: Permission change
        echo "[!] Trigger Condition activated: Modifying permissions on $TARGET_FILE..."
        sudo chmod 777 $TARGET_FILE
        sleep 1
        
        # Observation Source: ls -l
        echo "--------------------------------------------"
        echo "[>] OBSERVATION SOURCE: ls -l"
        echo "--------------------------------------------"
        ls -l $TARGET_FILE
        
        echo "[*] Restoring safe permissions (644)..."
        sudo chmod 644 $TARGET_FILE
        ls -l $TARGET_FILE
        echo ">> Context 1 Execution Complete."
        ;;

    # Assignment Context 2: File System & Inode Pressure
    4)
        echo ">> EXECUTING OS CONTEXT 2: File System Inode Pressure <<"
        echo "[*] Task Category: File System"
        echo "[*] OS Stress Condition: I/O saturation"
        echo "[*] Resource Constraint: Inode pressure"
        
        mkdir -p $STRESS_DIR
        FILE_THRESHOLD=50000
        
        # Trigger Condition: Threshold-based & I/O Saturation
        echo "[!] Trigger Condition: Threshold-based ($FILE_THRESHOLD files)"
        echo "[!] Applying I/O Saturation and Inode Pressure..."
        echo "    (Simulating massive influx of 32ms TDMA multi-physiological signal slices)"
        
        seq 1 $FILE_THRESHOLD | xargs -I{} -P 20 touch $STRESS_DIR/eeg_slice_{}.dat 2>/dev/null
        
        # Observation Source: df -i
        echo "--------------------------------------------"
        echo "[>] OBSERVATION SOURCE: df -i"
        echo "--------------------------------------------"
        df -i $STRESS_DIR
        
        echo ""
        echo "[*] Stress test concluded. Cleaning up to release Inodes..."
        rm -rf $STRESS_DIR
        echo ">> Context 2 Execution Complete."
        ;;

    0)
        echo "Exiting Control Panel..."
        break
        ;;
    *)
        echo "Invalid option."
        ;;
    esac
done