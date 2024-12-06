#!bin/bash

B_GREEN="\033[1;32m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_GREEN}. . . CONFIGURATION SCRIPT . . .${RESET}"

# Cleanslate Preinstall Config
sudo sh ./configCleanup.sh

# 00.Install K3d Requisites: 
# A. kubeclt:
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux

# Install and test validate checksum
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl and test to verify installation
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

    # # If you don't have root access, you may need to use a different directory: (A TESTER)
    # chmod +x kubectl
    # mkdir -p ~/.local/bin
    # mv ./kubectl ~/.local/bin/kubectl
    # # and then append (or prepend) ~/.local/bin to $PATH
    # export PATH=$PATH:~/.local/bin

# B. Docker
# https://get.docker.com/
if [ -x "$(command -v docker)" ]; then
	echo "${B_GREEN}Docker Already Installed!${RESET}"
else
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
fi

# 01.Install K3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d --version
# Create a cluster
k3d cluster create dev-app

# 02.Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for pods
kubectl wait --for=condition=Ready pods --all -n argocd
# get secret
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 
# apply yml
kubectl apply -f /confs/argocd/deploy.yml

kubectl create namespace dev

# Deploy

