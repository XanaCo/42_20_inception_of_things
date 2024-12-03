#!bin/bash

B_GREEN="\033[1;32m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_GREEN}. . . SERVER CONFIGURATION SCRIPT . . .${RESET}"

# Preinstall Config in the server node
if sudo apt-get update -y && \
sudo apt-get upgrade -y && \
sudo apt-get install curl -y && \
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh;
then
    echo "${B_GREEN}Preinstallation Succeded!${RESET}"
else
    echo "${B_RED}Error: Preinstallation Failed${RESET}"
    exit 1
fi

# Modify the K3s environment variables
if export INSTALL_K3S_EXEC="
--write-kubeconfig-mode=644 \
--bind-address=192.168.56.110 \
--node-ip 192.168.56.110 \
--advertise-address=192.168.56.110"; then
    echo "${B_GREEN}K3s Environment Variables Set!${RESET}"
else
    echo "${B_RED}Error: K3s Environment Variables Not Set!${RESET}"
    exit 1
fi

# Install K3s Controller Plane
if curl -sfL https://get.k3s.io | sh -; then
    echo "${B_GREEN}K3s Controller Plane Installed!${RESET}"
else
    echo "${B_RED}Error: K3s Controller Plane Not Installed!${RESET}"
    exit 1
fi

# Create ConfigMaps
if sudo kubectl create configmap app1 --from-file /vagrant/confs/app1/index.html && \
sudo kubectl create configmap app2 --from-file /vagrant/confs/app2/index.html && \
sudo kubectl create configmap app3 --from-file /vagrant/confs/app3/index.html; then
	echo "${B_GREEN}ConfigMaps Created!${RESET}"
else
	echo "${B_RED}Error: ConfigMaps Not Created!${RESET}"
	exit 1
fi

# Create Deployments
if sudo kubectl apply -f /vagrant/confs/app1/app1.yml && \
sudo kubectl apply -f /vagrant/confs/app2/app2.yml && \
sudo kubectl apply -f /vagrant/confs/app3/app3.yml; then
	echo "${B_GREEN}Deployments Created!${RESET}"
else
	echo "${B_RED}Error: Deployments Not Created!${RESET}"
	exit 1
fi

echo "${B_GREEN}. . . SERVER IS READY . . .${RESET}"
