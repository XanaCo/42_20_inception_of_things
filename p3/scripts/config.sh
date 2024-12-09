#!bin/bash

B_GREEN="\033[1;32m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_GREEN}. . . CONFIGURATION SCRIPT . . .${RESET}"

# Cleanslate Preinstall Config
cd "$(dirname "$0")"
sudo sh ./configCleanup.sh

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

# B. Docker : https://get.docker.com/
if ! [ -x "$(command -v docker)" ]; then
	sudo curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
else
	echo "${B_GREEN}Docker is already installed!${RESET}"
fi

# 01.Install K3d
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d --version
# Create a cluster
sudo k3d cluster create dev-app --wait

# 02.Install ArgoCD
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# sudo kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge --patch '{"data": {"server.insecure": "true"}}'

# Install ArgoCD CLI
# curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64

# wait for pods
sudo kubectl wait --for=condition=Ready pods --all -n argocd
sudo kubectl -n argocd get pods
# sleep 20

# Deploy
sudo kubectl apply -n argocd -f ../confs/argocd/deploy.yml
sudo kubectl apply -n dev -f ../confs/dev/app.yml

# Get argocd password
sleep 30
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443