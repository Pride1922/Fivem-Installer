Fivem-Installer
This script automates the configuration and installation of a FiveM server on a Linux machine. It provides options for a full installation or updating existing server components.

How to Use
Download the Installer Script: Run the following command to download the Fivem-Installer.sh script:

sudo wget https://raw.githubusercontent.com/Pride1922/Fivem-Installer/main/scripts/Fivem-Installer.sh


Make the Installer Script Executable: Make sure the installer script is executable:

sudo chmod +x Fivem-Installer.sh

Run the Installer Script: Launch the script to access the menu options for installation or updates:

sudo ./Fivem-Installer.sh


The installer will present the following options:

1 - Full-install: Downloads and runs the install.sh script to set up the server from scratch.
2 - Update Server: Downloads and runs the update.sh script to update the server components (Linux, FiveM, and TxAdmin).
0 - Exit: Exits the installer.
Post-Execution:

After running either the full install or update option, the corresponding script (install.sh or update.sh) is automatically deleted to keep the environment clean.
If the download of a script fails, an error message will be shown, and the script will not proceed until the issue is resolved.
Notes
Ensure you have an active internet connection as the script downloads additional files from the repository.
Run the installer with sudo privileges to allow necessary system configurations.