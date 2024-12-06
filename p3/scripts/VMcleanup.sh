#!bin/bash

# Clean up K3d
if [ -x "$(command -v k3d)" ]; then
	k3d cluster delete dev-app
	kubectl delete namespace argocd
	kubectl delete namespace dev
	rm -f /usr/local/bin/k3d
	rm /usr/local/bin/kubectl
	rm kubectl
	rm kubectl.sha256
	else
	echo "K3d is not installed"
fi

# Clean up Docker
if [ -x "$(command -v docker)" ]; then
	sudo docker rm -f $(docker ps -a -q)
	sudo docker rmi $(docker images -q)
	sudo docker system prune
	sudo docker volume prune
	sudo apt-get purge -y docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin
	sudo apt-get autoremove -y --purge docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin
	sudo rm -rf /var/lib/docker
	sudo rm get-docker.sh
	else
	echo "Docker is not installed"
fi

# Finish cleaning up
sudo apt-get clean 
sudo apt-get autoremove -y
