#!/bin/bash

# Colors for output
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED='\e[1;31m'
TEXT_BLUE='\e[1;34m'

# Directories
echo -e "${TEXT_YELLOW}Creating directories for FiveM...${TEXT_RESET}"
sudo mkdir -p /home/fivem/fivem_server
sudo mkdir -p /home/fivem/fivem_resources
sudo chown -R fivem:fivem /home/fivem

# Downloading FiveM
url="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
version=$(curl -sS "${url}" | grep OPTIONAL | sort | tail -1 | sed -n 's/.*LATEST OPTIONAL.."*//p' | sed 's/.$//')
echo -e "${TEXT_YELLOW}Installing Version: $version${TEXT_RESET}"

# Get the latest version URL dynamically
getnewversion=$(curl -sS "${url}" |
    sed -e 's/^<a href=["'"'"']//i' |
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep "$version" | awk '{ print $2 }' | sed -n 's/.*href="..\([^"]*\).*/\1/p')

# Construct full download URL and start download
newversion="${url}${getnewversion}"
echo -e "${TEXT_YELLOW}Downloading FiveM from: ${newversion}${TEXT_RESET}"
curl -O "$newversion" || { echo -e "${TEXT_RED}Failed to download FiveM. Please check the URL and try again.${TEXT_RESET}"; exit 1; }

# Extract the downloaded file
echo -e "${TEXT_YELLOW}Installing FiveM...${TEXT_RESET}"
tar -xf fx.tar.xz -C /home/fivem/fivem_server/ || { echo -e "${TEXT_RED}Failed to extract FiveM. Check the downloaded file.${TEXT_RESET}"; exit 1; }

# Clean up downloaded file
echo -e "${TEXT_YELLOW}Removing the downloaded file...${TEXT_RESET}"
rm fx.tar.xz

# Final message
echo -e "${TEXT_BLUE}FiveM installation finished successfully.${TEXT_RESET}"

# Remove the script file after execution
rm -- "$0"
