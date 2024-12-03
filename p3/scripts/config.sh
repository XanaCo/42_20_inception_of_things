#!bin/bash

B_GREEN="\033[1;32m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_GREEN}. . . CONFIGURATION SCRIPT . . .${RESET}"

# Preinstall Config
if sudo apt-get update -y && \
sudo apt-get upgrade -y && \
sudo apt-get install curl -y && \
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh;
then
    echo "${B_GREEN}Preinstallation Succeded!${RESET}"
else
    echo "${B_RED}Error: Preinstallation Already Done${RESET}"
fi

# install k3d if not installed
# install docker if not installed
