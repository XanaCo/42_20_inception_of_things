#!bin/bash

echo "WORKER NODE CONFIGURATION"

# Install curl in the worker node
sudo apt-get update
sudo apt-get install curl -y

# Modify the K3s environment variables
export INSTALL_K3S_EXEC="agent \
--server https://192.168.56.110:6443 \
--token-file "/vagrant/server_token.env" \
--node-ip=192.168.56.111
--flannel-iface=eth1"

# Install K3s Worker Node
curl -sfL https://get.k3s.io | sh -s -

# Remove the token file
sudo rm /vagrant/server_token.env

echo "K3s Worker Node is Ready!"