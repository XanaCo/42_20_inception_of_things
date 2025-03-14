#!bin/bash

B_GREEN="\033[1;32m"
B_RED="\033[1;31m"
RESET="\033[0m"

# Run as sudo or nothing happens
if [ ! "$(id -u)" -eq 0 ]; then
    echo "Run this script as ROOT or SUDO user"
	exit 1
fi

# Preinstall Config
cd "$(dirname "$0")"
sudo sh ./configCleanup.sh

echo "${B_GREEN}. . . CONFIGURATION SCRIPT . . .${RESET}"
# 00.Install K3d Requisites:
echo "${B_GREEN}. . . K3D REQUISITE PREINSTALL${RESET}"
# A. kubeclt: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
if ! [ -x "$(command -v kubectl)" ]; then
    echo "${B_GREEN}. . . KUBECTL INSTALL${RESET}"
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo kubectl version --client
else
    echo "${B_GREEN}Kubectl is already installed${RESET}"
fi
# B. Docker : https://get.docker.com/
if ! [ -x "$(command -v docker)" ]; then
    echo "${B_GREEN}. . . DOCKER INSTALL${RESET}"
	sudo curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
else
	echo "${B_GREEN}Docker is already installed!${RESET}"
fi

# 01.Install K3d and create our cluster
echo "${B_GREEN}. . . K3D INSTALL${RESET}"
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d --version
sudo k3d cluster create dev-app --wait

# 02.Install ArgoCD
echo "${B_GREEN}. . . ARGOCD INSTALL${RESET}"
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 10
echo "${B_GREEN}. . . WAIT FOR PODS ARGOCD TO BE READY${RESET}"
sudo kubectl wait --for=condition=Ready pods --all -n argocd
sudo kubectl -n argocd get pods

# 03.Deploy ArgoCD + app
echo "${B_GREEN}. . . DEPLOY APP${RESET}"
sudo kubectl apply -n argocd -f ../confs/argocd/deploy.yml

# 04.Redirections and port access
sleep 10
echo "${B_GREEN}. . . GET SECRET AND PORT-FORWARD ARGOCD${RESET}"
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > .argocd_pass
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &

echo "${B_GREEN}. . . WAIT FOR PODS DEV TO BE READY${RESET}"
sudo kubectl wait --for=condition=Ready pods --all -n dev
sudo kubectl -n dev get pods

while true
do
  sudo kubectl port-forward svc/wil-service -n dev 8888:8888
  echo "Port forwarding stopped or failed. Retrying in 5 seconds..."
  sleep 5
done