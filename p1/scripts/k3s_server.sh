#!/bin/bash
B_ORANGE="\033[1;34m"
B_YELLOW="\033[1;33m"
B_GREEN="\033[1;32m"
B_GREY="\033[1;30m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_YELLOW}Executing k3s_server.sh on $(hostname)${RESET}"

result=$(command -v curl)

# Checking if curl is already on the vm, then installing it if it is not
if [ -n "$result" ]; then
    echo "${B_ORANGE}curl is already installed${RESET}"
else
    echo "${B_ORANGE}curl isn't installed yet${RESET}"
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install curl -y
    echo "${B_GREEN}curl is now installed${RESET}"
fi

# Installing k3s in server mode
if k3s --version;then
    echo "${B_ORANGE}k3s is already installed${RESET}"
else
    if export INSTALL_K3S_EXEC="--node-ip=192.168.56.110"; then
        echo "${B_GREEN}INSTALL_K3S_EXEC set as expected${RESET}"
    else
        echo "${B_RED}error setting INSTALL_K3S_EXEC${RESET}"
        exit 1
    fi

    if curl -sfL https://get.k3s.io | sh -; then
        echo "${B_GREEN}K3s Server Installed!${RESET}"
    else
        echo "${B_RED}error installing K3s Server${RESET}"
        exit 1
    fi
fi

# Writing the server's token in a file in the shared folder /vagrant
# in order for the agent to be able to access it in the Worker VM
if sudo cat /var/lib/rancher/k3s/server/token > /vagrant/server-token; then
    echo "${B_GREEN}server token successfully copied to /vagrant/server-token${RESET}"
else
    echo "${B_RED}error: server token copy failed${RESET}"
    exit 1
fi

echo "Finished executing k3s_server.sh on $(hostname)"
