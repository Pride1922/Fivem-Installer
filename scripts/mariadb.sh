#!/bin/bash

# Colors for output
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED='\e[1;31m'
TEXT_BLUE='\e[1;34m'

# Function to pause the script
function pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    echo ""
}

# Prompt for MariaDB root password
clear
echo -e "${TEXT_YELLOW}Please create a password for the MariaDB root user:${TEXT_RESET}"
read -sp 'Password: ' SQLpassword
echo ""

# Update package lists
echo -e "${TEXT_YELLOW}Updating package lists...${TEXT_RESET}"
sudo apt-get update

# Install necessary packages
echo -e "${TEXT_YELLOW}Installing software-properties-common...${TEXT_RESET}"
sudo apt-get install -y software-properties-common

# Add MariaDB APT repository
echo -e "${TEXT_YELLOW}Adding MariaDB APT repository...${TEXT_RESET}"
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror.zol.co.zw/mariadb/repo/11.5/ubuntu noble main'

# Import MariaDB GPG key
echo -e "${TEXT_YELLOW}Importing MariaDB GPG key...${TEXT_RESET}"
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'

# Update package lists again
echo -e "${TEXT_YELLOW}Updating package lists after adding MariaDB repository...${TEXT_RESET}"
sudo apt-get update

# Install MariaDB server
echo -e "${TEXT_YELLOW}Installing MariaDB server...${TEXT_RESET}"
sudo apt-get install -y mariadb-server

# Secure MariaDB installation
echo -e "${TEXT_YELLOW}Securing MariaDB installation...${TEXT_RESET}"
sudo mysql_secure_installation <<EOF

y
$SQLpassword
$SQLpassword
y
y
y
y
EOF

# Allow remote access by modifying the bind address
echo -e "${TEXT_YELLOW}Configuring MariaDB to allow remote access...${TEXT_RESET}"
sudo sed -i "s/^bind-address\s*=.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Restart MariaDB to apply changes
echo -e "${TEXT_YELLOW}Restarting MariaDB service...${TEXT_RESET}"
sudo systemctl restart mariadb

# Create a user for FiveM with privileges
clear
echo -e "${TEXT_RED}Create FiveM user to access MariaDB${TEXT_RESET}"
echo -e "${TEXT_YELLOW}Adding new SQL user: Please input username.${TEXT_RESET}"
read -p 'Username: ' sqlusername
echo -e "${TEXT_YELLOW}Please type in password:${TEXT_RESET}"
read -sp 'Password: ' sqluserpassword
echo ""

# Grant privileges to the new user
echo -e "${TEXT_YELLOW}Granting privileges to the new user...${TEXT_RESET}"
sudo mysql -u root -p"$SQLpassword" <<-EOF
CREATE USER '${sqlusername}'@'%' IDENTIFIED BY '${sqluserpassword}';
GRANT ALL PRIVILEGES ON *.* TO '${sqlusername}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo -e "${TEXT_YELLOW}Username: $sqlusername with the password $sqluserpassword created."
echo "Please write them down. You will need them to configure TxAdmin.${TEXT_RESET}"

# Restart MariaDB to apply changes
echo -e "${TEXT_YELLOW}Restarting MariaDB service...${TEXT_RESET}"
sudo systemctl restart mariadb
pause

# Clean up script file
rm -- "$0"
