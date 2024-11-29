#!bin/bash

echo "SERVER NODE CONFIGURATION"

# Update and upgrade the system
sudo apt-get update
sudo apt-get install curl -y

# Install K3s Controller Plane
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE=644 sh -s - server

# Get the K3s server token
sudo cat /var/lib/rancher/k3s/server/token > /vagrant/server_token.txt

