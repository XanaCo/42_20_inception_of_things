#!bin/bash

echo "SERVER NODE CONFIGURATION"

# Install curl in the server node
sudo apt-get update
sudo apt-get install curl -y

# Modify the K3s environment variables
export INSTALL_K3S_EXEC="server \
--write-kubeconfig-mode=644 \
--node-ip 192.168.56.110 \
--bind-address=192.168.56.110 \
--advertise-address=192.168.56.110 
--flannel-iface=eth1"

# Install K3s Controller Plane
curl -sfL https://get.k3s.io | sh -s -

# Get the K3s server token
sudo cat /var/lib/rancher/k3s/server/token > /vagrant/server_token.env

echo "K3s Server Node is Ready!"