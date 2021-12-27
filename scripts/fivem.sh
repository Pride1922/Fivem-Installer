
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED='\e[1;31m'
TEXT_BLUE='\e[1;34m'


mkdir ~/fivem_server
mkdir ~/fivem_resources
chown fivem:fivem /home/fivem
url=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/
version=$(curl  -sS 'https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/' | grep OPTIONAL  | sort | tail -1 | sed -n 's/.*LATEST OPTIONAL.."*//p' | sed 's/.$//')
echo -e $TEXT_YELLOW
echo "Installing Version: $version"
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
newversion="${url}${getnewversion}"
echo -e $TEXT_YELLOW
echo $newversion
echo
echo "Downloading ..."
echo
echo -e $TEXT_RESET
curl -O $newversion
echo -e $TEXT_YELLOW
echo "Installing..."
echo -e $TEXT_RESET
tar -xf fx.tar.xz -C /home/fivem/fivem_server/
echo -e $TEXT_YELLOW
echo "Removing the downloaded file"
echo -e $TEXT_RESET
rm fx.tar.xz
echo -e $TEXT_BLUE
echo "Installation finished."
echo -e $TEXT_RESET
