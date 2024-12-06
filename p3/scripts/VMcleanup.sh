#!bin/bash

sudo rm /usr/local/bin/kubectl &&
rm kubectl &&
sudo apt-get purge -y docker docker-engine docker.io containerd runc &&
sudo apt-get autoremove -y &&
sudo rm -rf /var/lib/docker &&
sudo rm -f /usr/local/bin/k3d &&
k3d cluster delete dev-app &&
kubectl delete namespace argocd &&
kubectl delete namespace dev &&
rm -f get-docker.sh &&
sudo apt-get clean &&
sudo apt-get autoremove -y
