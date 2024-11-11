#!/bin/bash

# Function to download, execute, and remove a script
run_script() {
  local script_name="$1"
  local url="https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/$script_name"
  
  echo "Downloading $script_name..."
  if sudo wget -q "$url"; then
    sudo chmod +x "$script_name"
    sudo ./"$script_name"
    sudo rm "$script_name"
  else
    echo "Failed to download $script_name. Please check your internet connection or URL."
  fi
}

# Menu options
menu_option_one() {
  run_script "install.sh"
}

menu_option_two() {
  run_script "update.sh"
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

# Main menu loop
until [ "$selection" = "0" ]; do
  clear
  echo ""
  echo "    	1  -  Full-install"
  echo "    	2  -  Update Server (Linux, Fivem, and Txadmin)"
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
