#!/bin/bash

GREEN="\033[0;32m"
B_GREEN="\033[1;32m"
RED="\033[0;31m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_GREEN}. . . WORKER CONFIGURATION SCRIPT . . .${RESET}"

# Preinstall Config in the worker node
if sudo DEBIAN_FRONTEND=noninteractive apt-get update -y && \
sudo apt-get upgrade -y && \
sudo apt-get install curl -y;
then
    echo "${GREEN}Preinstallation Succeded!${RESET}"
else
    echo "${B_RED}Error: Preinstallation Failed${RESET}"
    exit 1
fi

# Modify the K3s environment variables
if export INSTALL_K3S_EXEC="agent \
--server https://192.168.56.110:6443 \
--token-file "/vagrant/scripts/node-token" \
--node-ip=192.168.56.111"; then
    echo "${GREEN}K3s Environment Variables Set!${RESET}"
else
    echo "${B_RED}Error: K3s Environment Variables Not Set!${RESET}"
    exit 1
fi

# Install K3s Worker Node
if curl -sfL https://get.k3s.io | sh -; then
    echo "${GREEN}K3s Worker Node Installed!${RESET}"
else
    echo "${B_RED}Error: K3s Worker Node Not Installed!${RESET}"
    exit 1
fi

# Remove the token file (for security)
if sudo rm /vagrant/scripts/node-token; then
    echo "${GREEN}K3s Server Token Removed!${RESET}"
else
    echo "${B_RED}Error: K3s Server Token Not Removed!${RESET}"
    exit 1
fi
