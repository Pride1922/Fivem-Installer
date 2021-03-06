#!/bin/bash

#######################FUNCTIONS###############################################################
function pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    echo ""
}
######################FUNCTIONS#################################################################

######################COLOURS################
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED='\e[1;31m'
TEXT_BLUE='\e[1;34m'
#######################COLOURS###################

###################################SET TIMEZONE#################################################
sudo timedatectl set-timezone Europe/Brussels
echo -e $TEXT_YELLOW
echo 'Timezone changed to Europe/Brussels'
echo -e $TEXT_RESET

###################################UPDATE STARTED################################################
sudo apt-get update
echo -e $TEXT_YELLOW
echo 'APT update finished...'
echo -e $TEXT_RESET

sudo apt-get dist-upgrade -y
echo -e $TEXT_YELLOW
echo 'APT distributive upgrade finished...'
echo -e $TEXT_RESET

sudo apt-get upgrade -y
echo -e $TEXT_YELLOW
echo 'APT upgrade finished...'
echo -e $TEXT_RESET
sudo apt-get autoremove -y
echo -e $TEXT_YELLOW
echo 'APT auto remove finished...'
echo -e $TEXT_RESET
clear
echo -e $TEXT_BLUE
echo 'Server is updated... Moving on'
pause
###################################UPDATE FINISHED################################################

###############CREATE ADMINISTRATOR###############################################################
clear
echo -e $TEXT_RED
echo 'Create server administrator'
echo -e $TEXT_RESET

echo -e $TEXT_RESETecho -e $TEXT_YELLOW
echo 'Adding new administrator: Please input username.'
echo -e $TEXT_RESET
read -p 'Username:' username
echo -e $TEXT_YELLOW
echo 'Administrator created. Please type in password:'
echo -e $TEXT_RESET
read -sp 'Password:' password
sudo useradd -m -p $password -s /bin/bash $username
echo
clear
echo -e $TEXT_BLUE
echo Thank you $username, we now have your login details.
echo -e $TEXT_RESET
usermod -aG sudo $username
pause
##################ADMINISTRATOR CREATED############################################################

###############CREATE FIVEM USER###############################################################
clear
echo -e $TEXT_YELLOW
echo 'We are gonna create an user without privileges: fivem'
echo -e $TEXT_RESET
sudo useradd -m -p fivem -s /bin/bash fivem
echo -e $TEXT_RED
echo 'User fivem is created. Password is also fivem.'
echo 'Please write it down. You are going to need it later.'
echo -e $TEXT_RESET
pause
clear
##################FIVEM USER CREATED############################################################

#######################INSTALL DEPENDENCY#####################################################
###Dependency####
echo -e $TEXT_RED
echo 'We need to install Curl.'
echo -e $TEXT_RESET
pause
sudo apt update
sudo apt install curl -y
########################################################

################################MARIADB###################
clear
echo -e $TEXT_RED
echo 'Next we will install Mariadb. This is our database manager.'
echo -e $TEXT_RESET
pause
wget https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/mariadb.sh
sudo chmod +x mariadb.sh
sudo ./mariadb.sh
##########################################################

################################FIVEM###################
clear
echo -e $TEXT_RED
echo 'Next we will install fivem. We will create the folders for you.'
echo -e $TEXT_RESET
pause
wget https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/fivem.sh -P /home/fivem/
sudo chown fivem:fivem /home/fivem/fivem.sh
sudo chmod +x /home/fivem/fivem.sh
cd /home/fivem/
sudo -u fivem ./fivem.sh
pause
#######################FIVEM INSTALLED####################################################

#######################FIVEM SERVICE######################################################
cat << EOF >/etc/systemd/system/fivem.service

[Unit]
Description=Fivem Server
After=network.service
[Service]
WorkingDirectory=/home/fivem/fivem_resources/
ExecStart=/home/fivem/fivem_server/run.sh
KillMode=control-group
[Install]
WantedBy=default.target

EOF


clear
echo -e $TEXT_RED
echo 'Server is installed and ready to start.'
echo 'On the next screen you will be asked to go to your browser and login with your cfx account and the pin.'
echo -e $TEXT_RESET
pause
systemctl enable fivem.service
cd /home/fivem/fivem_server
sudo -u fivem ./run.sh
#systemctl start fivem.service
#############################

if [ -f /var/run/reboot-required ]; then
    echo -e $TEXT_RED_B
    echo 'Reboot required!'
    echo -e $TEXT_RESET
    sudo reboot now
fi
sudo rm install.sh