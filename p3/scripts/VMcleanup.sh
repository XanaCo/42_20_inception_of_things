#!bin/bash

# Clean up Docker
sudo docker rm -f $(docker ps -a -q)
sudo docker rmi $(docker images -q)
sudo docker system prune
sudo docker volume prune
sudo apt-get purge -y docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin
sudo apt-get autoremove -y --purge docker-buildx-plugin docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm get-docker.sh

# Clean up K3d
sudo k3d cluster delete dev-app
sudo kubectl delete namespace argocd
sudo kubectl delete namespace dev
sudo rm -f /usr/local/bin/k3d
sudo rm /usr/local/bin/kubectl
sudo rm kubectl
sudo rm kubectl.sha256

# Finish cleaning up
sudo apt-get clean 
sudo apt-get autoremove -y
