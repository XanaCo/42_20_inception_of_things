#!/bin/bash
echo "Executing k3s_agent.sh on $(hostname)"

result=$(command -v curl)

# Checking if curl is already on the vm, then installing it if it is not
if [ -n "$result" ]; then
    echo "curl is already installed"
else
    echo "curl isn't installed yet"
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install curl -y
    echo "curl is now installed"
fi

# Installing k3s in agent mode
export INSTALL_K3S_EXEC="agent --server=https://192.168.56.110:6443 --node-ip=192.168.56.111 --token-file=/vagrant/server-token"
curl -sfL https://get.k3s.io | sh -

sudo rm /vagrant/server-token

echo "Finished executing k3s_agent.sh on $(hostname)"
