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
sudo adduser $username  --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$username:$password" | sudo chpasswd
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
echo -e $TEXT_RED
echo 'Lets create an user without privileges. This is your FTP user.'
echo -e $TEXT_RESET

echo -e $TEXT_RESETecho -e $TEXT_YELLOW
echo 'Adding new user: Please input username.'
echo -e $TEXT_RESET
read -p 'Username:' username_fivem
echo -e $TEXT_YELLOW
echo 'Administrator created. Please type in password:'
echo -e $TEXT_RESET
read -sp 'Password:' password_fivem
sudo adduser $username_fivem  --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$username_fivem:$password_fivem" | sudo chpasswd
echo
clear
echo -e $TEXT_BLUE
echo Thank you $username_fivem, we now have your login details.
echo Please write it down!! Username: $username_fivem Password: $password_fivem You need this login to connect using filezila.
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

################################VSFTPD###################
clear
echo -e $TEXT_RED
echo 'Next we will install VSFTPD. This is our FTP Server which will allow you to remote access your files.'
echo -e $TEXT_RESET
pause
wget https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/vsftpd.sh
sudo chmod +x vsftpd.sh
sudo ./vsftpd.sh
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
