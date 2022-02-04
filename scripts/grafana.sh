#!/bin/bash
######################HOW TO RUN################################################

wget https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/grafana.sh
sudo chmod +x grafana.sh
./grafana.sh

######################HOW TO RUN################################################



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

clear
echo -e $TEXT_YELLOW
echo 'Lets install the APT packages for grafana'
echo -e $TEXT_RESET
pause

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
echo "deb https://packages.grafana.com/enterprise/deb beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

clear
echo -e $TEXT_YELLOW
echo 'Packages should be ready to install. Lets update the server...'
echo -e $TEXT_RESET
pause

sudo apt-get update

clear
echo -e $TEXT_YELLOW
echo 'Everything should be up to date. Lets install grafana enterprise'
echo -e $TEXT_RESET
pause

sudo apt-get install grafana-enterprise -y

clear
echo -e $TEXT_YELLOW
echo 'Grafana is installed. We are gonna configure it so you can access it through HTTP...'
echo -e $TEXT_RESET
pause

sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo ufw allow 3000/tcp
sudo ufw reload
sudo grafana-cli plugins install sni-pnp-datasource
sudo systemctl restart grafana-server.service
cd /usr/local/pnp4nagios/share/application/controllers/
sudo wget -O api.php "https://github.com/lingej/pnp-metrics-api/raw/master/application/controller/api.php"
sudo sh -c "sed -i '/Require valid-user/a\        Require ip 127.0.0.1 ::1' /etc/apache2/sites-enabled/pnp4nagios.conf"
sudo systemctl restart apache2.service


clear
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
echo -e $TEXT_YELLOW
echo 'All done. Please navigate to http://'$ip4':3000 and create a user.'
echo -e $TEXT_RESET
pause


