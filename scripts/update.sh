#!/bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'

echo -e $TEXT_YELLOW
echo "We are going to update your Linux server, Fivem server and Txadmin"
echo "We will also check if the Linux server needs to be rebooted"
echo -e $TEXT_RESET
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


url=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/
version=$(curl  -sS 'https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/' | grep OPTIONAL  | sort | tail -1 | sed -n 's/.*LATEST OPTIONAL.."*//p' | sed 's/.$//')
echo -e $TEXT_YELLOW
echo "Updating now to Version: $version"
echo -e $TEXT_RESET
getnewversion=$(curl 'https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/' |
    sed -e 's/^<a href=["'"'"']//i' | 
    awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |  grep $version | awk '{ print $2 }' | sed -n 's/.*href="..\([^"]*\).*/\1/p')
echo
echo -e $TEXT_YELLOW
echo $getnewversion
echo 
echo "Converting to url ..."
echo -e $TEXT_RESET
newversion=$"${url}${getnewversion}"
echo -e $TEXT_YELLOW
echo $newversion
echo
echo "Starting update ..."
echo 
echo "Stopping Fivem"
echo -e $TEXT_RESET
systemctl stop fivem
echo -e $TEXT_YELLOW
echo "Server is stopped. Let's download..."
echo -e $TEXT_RESET
curl -O "$newversion"
echo -e $TEXT_YELLOW
echo "Updating servers..."
echo -e $TEXT_RESET
tar -xf fx.tar.xz -C /home/fivem/fivem_server/
echo -e $TEXT_YELLOW
echo "Removing the downloaded file"
echo -e $TEXT_RESET
rm fx.tar.xz
echo -e $TEXT_YELLOW
echo "Fivem is updated. Lets update txadmin to the latest version!"
echo -e $TEXT_RESET
curl -s https://api.github.com/repos/tabarra/txAdmin/releases/latest \
| grep "monitor.zip" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

unzip -o -q monitor.zip -d /home/fivem/fivem_server/alpine/opt/cfx-server/citizen/system_resources/monitor/
sudo rm monitor.zip

echo -e $TEXT_YELLOW
echo "Update done We are gonna check if your server needs to be restarted!"
echo -e $TEXT_RESET

if [ -f /var/run/reboot-required ]; then
    echo -e $TEXT_RED_B
    echo "Reboot required... We are going to reboot your server. This should take less than a minute "
    echo -e $TEXT_RESET
   
fi

echo
echo "All done - Starting Fivem Server"
echo -e $TEXT_RESET
systemctl start fivem
sudo rm update.sh