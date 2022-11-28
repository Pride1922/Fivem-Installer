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

echo -e $TEXT_YELLOW
echo 'Starting installation of FTP Server...'
echo -e $TEXT_RESET
sudo apt update
sudo apt install vsftpd -y
sudo mv /etc/vsftpd.conf /etc/vsftpd.origin


cat << EOF >/etc/vsftpd.conf
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

sudo systemctl restart vsftpd

clear
echo -e $TEXT_BLUE
echo You can now access your files using Filezilla. 
echo -e $TEXT_RESET
pause
