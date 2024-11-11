#!/bin/bash

# Functions
function pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    echo ""
}

# Colors
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED='\e[1;31m'
TEXT_BLUE='\e[1;34m'

# Start Installation
echo -e "${TEXT_YELLOW}Starting installation of FTP Server...${TEXT_RESET}"
sudo apt update
sudo apt install -y vsftpd

# Check if VSFTPD was installed successfully
if ! command -v vsftpd &> /dev/null; then
    echo -e "${TEXT_RED}VSFTPD installation failed. Please check your network connection and try again.${TEXT_RESET}"
    exit 1
fi

# Backup original config and create a new one
sudo mv /etc/vsftpd.conf /etc/vsftpd.conf.bak

cat << EOF | sudo tee /etc/vsftpd.conf > /dev/null
listen=NO
listen_ipv6=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
allow_writeable_chroot=YES
EOF

# Restart and enable VSFTPD service
sudo systemctl restart vsftpd
sudo systemctl enable vsftpd

# Output success message
clear
echo -e "${TEXT_BLUE}FTP Server (VSFTPD) installed and configured successfully.${TEXT_RESET}"
echo -e "${TEXT_BLUE}You can now access your server's files using an FTP client like FileZilla.${TEXT_RESET}"
echo -e "${TEXT_BLUE}Ensure to log in with a local user account and the corresponding password.${TEXT_RESET}"
pause

# Clean up script file
rm -- "$0"
