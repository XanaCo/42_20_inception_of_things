#!bin/bash
#
# MAKE VBOXUSER A SUDOER BEFORE RUNNING THIS SCRIPT:
# sudo usermod -aG sudo vboxuser
# su vboxuser
#

B_GREEN="\033[1;32m"
RESET="\033[0m"

if [ ! "$(id -u)" -eq 0 ]; then
    echo "Run this script as ROOT or SUDO user"
	exit 1
fi

echo "${B_GREEN}. . . STARTUP SCRIPT . . .${RESET}"

# Create ssh public key
if [ ! -f ~/.ssh/id_ed25519 ]; then
	ssh-keygen -t ed25519 -C "ancolmen@student.42.fr"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_ed25519
	cat ~/.ssh/id_ed25519.pub
else
	echo "${B_GREEN}SSH key already exists${RESET}"
fi

#Install curl
if ! [ -x "$(command -v curl)" ]; then
	sudo apt-get install curl -y
else
	echo "${B_GREEN}Curl is already installed${RESET}"
fi

# Install git
if ! [ -x "$(command -v git)" ]; then
	sudo apt-get install git -y
else
	echo "${B_GREEN}Git is already installed${RESET}"
fi

# Install vagrant
if ! [ -x "$(command -v vagrant)" ]; then
	sudo apt-get install vagrant -y
else
	echo "${B_GREEN}Vagrant is already installed${RESET}"
fi

# Install VSCode
if ! [ -x "$(command -v code)" ]; then
	sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt-get update -y
	sudo apt-get install code -y
else
	echo "${B_GREEN}VSCode is already installed${RESET}"
fi

# Instal Virtualbox
if ! [ -x "$(command -v virtualbox)" ]; then
      sudo apt install curl wget gnupg2 lsb-release -y
      curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/vbox.gpg
      curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
      echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
      sudo apt update
      sudo apt install linux-headers-$(uname -r) dkms -y
      sudo apt install virtualbox-7.0 -y
else
	echo "${B_GREEN}Virtualbox is already installed${RESET}"
fi

# Make aliases
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

echo "${B_GREEN}. . . STARTUP COMPLETE . . .${RESET}"
