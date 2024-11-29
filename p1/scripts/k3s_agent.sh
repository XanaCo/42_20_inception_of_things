#!/bin/bash

result=$(command -v curl)

if [ -n "$result" ]; then
    echo "curl is already installed"
else
    echo "curl isn't installed yet"
    sudo apt-get update
    # sudo apt-get upgrade -y
    sudo apt-get install curl -y
    echo "curl is now installed"
fi

# curl -sfL https://get.k3s.io | sh -
token=$(cat /vagrant/server-token)
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$token sh -

sudo rm /vagrant/server-token