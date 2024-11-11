#!/bin/bash

# Colors
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'

# Start Updates
echo -e "${TEXT_YELLOW}Updating your Linux server, FiveM server, and TxAdmin...${TEXT_RESET}"
echo "Checking if a reboot is needed after the update."

# Update the server
sudo apt-get update && echo -e "${TEXT_YELLOW}APT update finished...${TEXT_RESET}"
sudo apt-get dist-upgrade -y && echo -e "${TEXT_YELLOW}APT dist-upgrade finished...${TEXT_RESET}"
sudo apt-get upgrade -y && echo -e "${TEXT_YELLOW}APT upgrade finished...${TEXT_RESET}"
sudo apt-get autoremove -y && echo -e "${TEXT_YELLOW}APT auto-remove finished...${TEXT_RESET}"
sudo apt install -y zip

# Define the URL for FiveM server update
url="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
version=$(curl -sS "${url}" | grep OPTIONAL | sort | tail -1 | sed -n 's/.*LATEST OPTIONAL.."*//p' | sed 's/.$//')

echo -e "${TEXT_YELLOW}Updating FiveM server to Version: $version${TEXT_RESET}"

# Construct the download URL
getnewversion=$(curl -sS "${url}" |
    sed -e 's/^<a href=["'"'"']//i' |
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep "$version" | awk '{ print $2 }' | sed -n 's/.*href="..\([^"]*\).*/\1/p')
newversion="${url}${getnewversion}"

# Stop FiveM before updating
echo -e "${TEXT_YELLOW}Stopping FiveM server for update...${TEXT_RESET}"
sudo systemctl stop fivem

# Download and update FiveM
echo -e "${TEXT_YELLOW}Downloading new FiveM version from: $newversion${TEXT_RESET}"
curl -O "$newversion" || { echo -e "${TEXT_RED_B}Failed to download FiveM update. Exiting.${TEXT_RESET}"; exit 1; }
echo -e "${TEXT_YELLOW}Extracting and updating FiveM files...${TEXT_RESET}"
tar -xf fx.tar.xz -C /home/fivem/fivem_server/ || { echo -e "${TEXT_RED_B}Failed to extract FiveM files. Exiting.${TEXT_RESET}"; exit 1; }
rm fx.tar.xz

# TxAdmin update
echo -e "${TEXT_YELLOW}Updating TxAdmin to the latest version...${TEXT_RESET}"
curl -s https://api.github.com/repos/tabarra/txAdmin/releases/latest | grep "monitor.zip" | cut -d : -f 2,3 | tr -d \" | wget -qi -
unzip -o -q monitor.zip -d /home/fivem/fivem_server/alpine/opt/cfx-server/citizen/system_resources/monitor/ || { echo -e "${TEXT_RED_B}Failed to update TxAdmin. Exiting.${TEXT_RESET}"; exit 1; }
rm monitor.zip

# Reboot check
echo -e "${TEXT_YELLOW}Checking if a reboot is required...${TEXT_RESET}"
if [ -f /var/run/reboot-required ]; then
    echo -e "${TEXT_RED_B}Reboot required. Rebooting server now.${TEXT_RESET}"
    sudo reboot
else
    echo -e "${TEXT_BLUE}No reboot required. Starting FiveM server...${TEXT_RESET}"
    sudo systemctl start fivem
fi
