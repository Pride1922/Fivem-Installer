#!/bin/bash

menu_option_one() {
  sudo wget https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/install.sh
  sudo chmod +x install.sh
  sudo ./install.sh
}

menu_option_two() {
  echo "Some super cool code by John."
}

press_enter() {
  echo ""
  echo -n "	Press Enter to continue "
  read
  clear
}

incorrect_selection() {
  echo "Incorrect selection! Try again."
}

until [ "$selection" = "0" ]; do
  clear
  echo ""
  echo "    	1  -  Full-install"
  echo "    	2  -  Update Server"
  echo "    	0  -  Exit"
  echo ""
  echo -n "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_one ; press_enter ;;
    2 ) clear ; menu_option_two ; press_enter ;;
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done