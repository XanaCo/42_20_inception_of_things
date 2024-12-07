#!bin/bash

B_GREEN="\033[1;32m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_GREEN}. . . CONFIGURATION SCRIPT . . .${RESET}"

# Cleanslate Preinstall Config
cd "$(dirname "$0")"
sudo sh ./configCleanup.sh
sleep 2

# 00.Install K3d Requisites: 
# A. kubeclt: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
if ! [ -x "$(command -v kubectl)" ]; then
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    # curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    # echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    # Install kubectl and test to verify installation
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo kubectl version --client
    # # If you don't have root access, you may need to use a different directory: (A TESTER)
    # chmod +x kubectl
    # mkdir -p ~/.local/bin
    # mv ./kubectl ~/.local/bin/kubectl
    # # and then append (or prepend) ~/.local/bin to $PATH
    # export PATH=$PATH:~/.local/bin
else
    echo "${B_GREEN}Kubectl is already installed${RESET}"
fi

sleep 2
# B. Docker : https://get.docker.com/
if ! [ -x "$(command -v docker)" ]; then
	sudo curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
else
	echo "${B_GREEN}Docker is already installed!${RESET}"
fi

sleep 2
# 01.Install K3d
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d --version
# Create a cluster
sudo k3d cluster create dev-app --wait

sleep 2
# 02.Install ArgoCD
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for pods
sudo kubectl wait --for=condition=Ready pods --all -n argocd
sudo kubectl -n argocd get pods

sleep 2
# Get argocd password
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 
# Deploy
sudo kubectl apply -f ../confs/argocd/deploy.yml

