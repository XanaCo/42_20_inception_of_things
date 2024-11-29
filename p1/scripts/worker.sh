#!bin/bash

echo "WORKER NODE CONFIGURATION"

# Update and upgrade the system
sudo apt-get update
sudo apt-get install curl -y

# Get the K3s server token
TOKEN=$(cat /vagrant/server_token.txt)

# Install K3s Worker Node
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN sh -s - agent

# Verify the K3s server is running
sudo kubectl get nodes