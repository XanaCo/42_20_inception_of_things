#!bin/bash
#
# MAKE VBOXUSER A SUDOER BEFORE RUNNING THIS SCRIPT:
# sudo usermod -aG sudo vboxuser
# su vboxuser
#

B_GREEN="\033[1;32m"
RESET="\033[0m"

echo "${B_GREEN}. . . STARTUP SCRIPT . . .${RESET}"

# Install VSCode
if ! command -v code &> /dev/null
then
	sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt-get update -y
	sudo apt-get install code -y
else
	echo "${B_GREEN}VSCode is already installed${RESET}"
fi

#Install curl
if ! command -v curl &> /dev/null
then
	sudo apt-get install curl -y
else
	echo "${B_GREEN}Curl is already installed${RESET}"
fi

# Install git
if ! command -v git &> /dev/null
then
	sudo apt-get install git -y
else
	echo "${B_GREEN}Git is already installed${RESET}"
fi

# Make aliases
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

# Create ssh public key
if [ ! -f ~/.ssh/id_ed25519 ]; then
	ssh-keygen -t ed25519 -C "ancolmen@student.42.fr"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_ed25519
	cat ~/.ssh/id_ed25519.pub
else
	echo "${B_GREEN}SSH key already exists${RESET}"
fi

echo "${B_GREEN}. . . STARTUP COMPLETE . . .${RESET}"
