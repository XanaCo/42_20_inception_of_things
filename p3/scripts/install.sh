#!/bin/bash

sudo dnf update
sudo dnf install ca-certificates curl

# install docker and kubectl
if command -v kubectl &>/dev/null; then
	echo "Kubectl installation found"
else
	curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
	sudo chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
	kubectl version --client

	sleep 10
fi

if command -v docker &>/dev/null; then
	echo "Docker installation found"
else
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
fi

# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d --version

# create a single node cluster
k3d cluster create dev-cluster

kubectl create namespace argocd
kubectl create namespace dev

kubectl create configmap -n dev app-html --from-file '../dev/index.html'
kubectl apply -n dev -f '../dev/dev.yaml'

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 10

kubectl wait pod \
	--all \
	--for=condition=Ready \
	--namespace=argocd

kubectl -n argocd get pods
echo "All pods are ready"

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

kubectl apply -n argocd -f ../confs/ingress.yaml
kubectl apply -n argocd -f ../confs/project.yaml
kubectl apply -n argocd -f ../confs/argocd.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443
