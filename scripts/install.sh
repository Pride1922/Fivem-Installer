#!/bin/bash

# Function Definitions
function pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    echo ""
}

# Colors
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED='\e[1;31m'
TEXT_BLUE='\e[1;34m'
TEXT_RED_B='\e[1;31m'

# Prompt user for timezone
echo -e "${TEXT_YELLOW}Please enter your timezone (e.g., Europe/Brussels):${TEXT_RESET}"
read -p 'Timezone: ' timezone

if timedatectl list-timezones | grep -q "^$timezone$"; then
    sudo timedatectl set-timezone "$timezone"
    echo -e "${TEXT_YELLOW}Timezone changed to $timezone${TEXT_RESET}"
else
    echo -e "${TEXT_RED}Invalid timezone. Please re-run the script and enter a valid timezone.${TEXT_RESET}"
    exit 1
fi

# Update and Upgrade System
echo -e "${TEXT_YELLOW}Starting system update...${TEXT_RESET}"
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y
echo -e "${TEXT_BLUE}System update completed.${TEXT_RESET}"
pause

# Create Administrator User
clear
echo -e "${TEXT_RED}Create server administrator${TEXT_RESET}"
echo -e "${TEXT_YELLOW}Please input administrator username:${TEXT_RESET}"
read -p 'Username: ' username
echo -e "${TEXT_YELLOW}Please type in password:${TEXT_RESET}"
read -sp 'Password: ' password
sudo adduser "$username" --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$username:$password" | sudo chpasswd
sudo usermod -aG sudo "$username"
echo -e "${TEXT_BLUE}Administrator $username created successfully.${TEXT_RESET}"
pause

# Create FTP User
clear
echo -e "${TEXT_RED}Creating an FTP user without privileges.${TEXT_RESET}"
echo -e "${TEXT_YELLOW}Please input FTP username:${TEXT_RESET}"
read -p 'Username: ' username_fivem
echo -e "${TEXT_YELLOW}Please type in FTP password:${TEXT_RESET}"
read -sp 'Password: ' password_fivem
sudo adduser "$username_fivem" --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$username_fivem:$password_fivem" | sudo chpasswd
echo -e "${TEXT_BLUE}FTP user $username_fivem created successfully. Save these credentials for FTP access (e.g., using FileZilla).${TEXT_RESET}"
pause

# Install Curl
echo -e "${TEXT_RED}Installing Curl...${TEXT_RESET}"
pause
sudo apt-get install -y curl

# Install MariaDB
clear
echo -e "${TEXT_RED}Installing MariaDB for database management.${TEXT_RESET}"
pause
wget -q https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/mariadb.sh
if [ -f mariadb.sh ]; then
    sudo chmod +x mariadb.sh
    sudo ./mariadb.sh
    sudo rm mariadb.sh
else
    echo -e "${TEXT_RED}MariaDB installation script download failed.${TEXT_RESET}"
fi

# Install VSFTPD
clear
echo -e "${TEXT_RED}Installing VSFTPD for FTP access.${TEXT_RESET}"
pause
wget -q https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/vsftpd.sh
if [ -f vsftpd.sh ]; then
    sudo chmod +x vsftpd.sh
    sudo ./vsftpd.sh
    sudo rm vsftpd.sh
else
    echo -e "${TEXT_RED}VSFTPD installation script download failed.${TEXT_RESET}"
fi

# Install FiveM
clear
echo -e "${TEXT_RED}Installing FiveM server files...${TEXT_RESET}"
pause
wget -q https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/fivem.sh -P /home/fivem/
sudo chown fivem:fivem /home/fivem/fivem.sh
sudo chmod +x /home/fivem/fivem.sh
cd /home/fivem/
sudo -u fivem ./fivem.sh
pause

# Configure FiveM as a systemd Service
echo -e "${TEXT_YELLOW}Configuring FiveM as a systemd service...${TEXT_RESET}"
cat << EOF | sudo tee /etc/systemd/system/fivem.service > /dev/null
[Unit]
Description=FiveM Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/fivem/fivem_server
ExecStart=/home/fivem/fivem_server/run.sh +exec /home/fivem/fivem_resources/server.cfg
Restart=always
User=fivem
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the FiveM service
sudo systemctl daemon-reload
sudo systemctl enable fivem
echo -e "${TEXT_YELLOW}Starting FiveM server...${TEXT_RESET}"
sudo systemctl start fivem

# Final message
clear
echo -e "${TEXT_RED}Server installation and setup are complete.${TEXT_RESET}"
echo 'To manage the server, use systemctl commands like:'
echo '  sudo systemctl start fivem'
echo '  sudo systemctl stop fivem'
echo '  sudo systemctl restart fivem'

# Check if reboot is required
if [ -f /var/run/reboot-required ]; then
    echo -e "${TEXT_RED_B}Reboot required! Rebooting now...${TEXT_RESET}"
    sudo reboot
else
    echo -e "${TEXT_BLUE}No reboot required. Installation complete.${TEXT_RESET}"
fi

# Clean up
sudo rm "$0"
