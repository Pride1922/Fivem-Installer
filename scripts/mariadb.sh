#!/bin/bash

######################COLOURS################
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED='\e[1;31m'
TEXT_BLUE='\e[1;34m'
#######################COLOURS###################

#######################FUNCTIONS###############################################################
function pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    echo ""
}
##############################PAUSE###########################################################

clear
echo -e $TEXT_YELLOW
echo 'Please create a password for the user root under Mariadb:'
echo -e $TEXT_RESET
read -sp 'Password:' SQLpassword
apt update
debconf-set-selections <<< 'mariadb-server-10.3 mysql-server/root_password password $SQLpassword'
debconf-set-selections <<< 'mariadb-server-10.3 mysql-server/root_password_again password $SQLpassword'
apt update
apt install mariadb-server-10.6 -y

mysql -u root <<-EOF
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

clear
echo -e $TEXT_YELLOW
echo 'Mariadb installed and configured with safe options.'
echo -e $TEXT_RESET
pause

clear
echo -e $TEXT_RED
echo 'Create Fivem user to access MariaDB'
echo -e $TEXT_RESET

echo -e $TEXT_RESETecho -e $TEXT_YELLOW
echo 'Adding new SQL user: Please input username.'
echo -e $TEXT_RESET
read -p 'Username:' sqlusername
echo -e $TEXT_YELLOW
echo 'Please type in password:'
echo -e $TEXT_RESET
read -sp 'Password:' sqluserpassword

mysql -u root <<-EOF
GRANT ALL PRIVILEGES ON *.* TO '${sqlusername}'@'%'    IDENTIFIED BY '${sqluserpassword}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo -e $TEXT_YELLOW
echo "Username: $sqlusername with the password $sqluserpassword created."
echo "Please write them down. You are going to need it to configure txadmin"
echo -e $TEXT_RESET
systemctl restart mariadb
pause
rm mariadb.sh
