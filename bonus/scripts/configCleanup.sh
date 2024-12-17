#!bin/bash

B_GREEN="\033[1;32m"
RESET="\033[0m"

if [ ! "$(id -u)" -eq 0 ]; then
    echo "Run this script as ROOT or SUDO user"
	exit 1
fi

echo "${B_GREEN}. . . CLEANUP SCRIPT . . .${RESET}"

cd "$(dirname "$0")"

# Clean up K3d
if [ -x "$(command -v k3d)" ]; then
	sudo k3d cluster delete -a
	sudo kubectl delete namespace --all
	sudo rm -f /usr/local/bin/k3d
	sudo rm /usr/local/bin/kubectl
	sudo rm kubectl
	sudo rm kubectl.sha256
else
	echo "${B_GREEN}K3d is not installed${RESET}"
fi

# Clean up Docker
if [ -x "$(command -v docker)" ]; then
	sudo docker rm -f $(docker ps -a -q)
	sudo docker rmi $(docker images -q)
	sudo docker system prune -af
	sudo docker volume prune -f
	sudo apt-get purge -y docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin
	sudo apt-get autoremove -y --purge
	sudo rm -rf /var/lib/docker
	sudo rm get-docker.sh
else
	echo "${B_GREEN}Docker is not installed${RESET}"
fi

# Remove argocd pass
if [ -f .gitlab_pass ]; then
	sudo rm .gitlab_pass
	sudo rm .argocd_pass
	sudo rm get_helm.sh
fi

# Finish cleaning up
sudo apt-get clean 
sudo apt-get autoremove -y

echo "${B_GREEN}. . . CLEANUP COMPLETE . . .${RESET}"
