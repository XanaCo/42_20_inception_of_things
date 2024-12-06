#!bin/bash

sudo rm /usr/local/bin/kubectl
rm kubectl
rm kubectl.sha256
rm get-docker.sh
sudo docker rm -f $(docker ps -a -q)
sudo docker rmi $(docker images -q)
sudo docker system prune
sudo docker volume prune
sudo rm -rf /var/lib/docker
sudo k3d cluster delete dev-app
sudo rm -f /usr/local/bin/k3d
sudo kubectl delete namespace argocd
sudo kubectl delete namespace dev

sudo apt-get clean 
sudo apt-get autoremove -y
