#!/bin/bash

echo "Execution of config_vm.sh starting..."

# Updating and upgrading packages
sudo apt update && sudo apt upgrade -y

# Install curl if necessary
if command -v curl; then
    echo "${B_ORANGE}curl is already installed${RESET}"
else
    sudo apt-get install curl -y
    echo "${B_GREEN}curl is now installed${RESET}"
fi

# Install docker if necessary
if docker --version; then
    echo "docker is already installed on your machine"
else
    sudo apt install docker.io
    docker --version || {
        echo "error: docker failed to install"
        exit 1
    }
    echo "docker successfully installed"
fi

# Install kubectl if necessary
if kubectl version; then
    echo "kubectl is already installed on your machine"
else
    if (uname -m | grep "x86_64"); then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" || {
            echo "error downloading the latest version of kubectl"
            exit 1
        }
    else
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" || {
            echo "error downloading the latest version of kubectl"
            exit 1
        }
    fi
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    kubectl version || {
        echo "error: kubectl failed to install"
        exit 1
    }
    echo "kubectl successfully installed"
fi

# Installing the latest version of k3d
if curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash; then
    echo "Successful installation of k3d latest release"
else
    echo "Failure during installation of k3d latest release"
    exit 1
fi

# Creating argocd & dev namespaces
kubectl create -f ./k3d_config.yml || {
    echo "error: failure during the creation of dev & argocd namespaces"
    exit 1
}

# Installing ArgoCD in the argocd namespace
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || {
    echo "error: failed installation of ArgoCD"
    exit 1
}

# Installing ArgoCD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 || {
    echo "error: failed download of ArgoCD CLI"
    exit 1
}

sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd || {
    echo "error: failed installation of ArgoCD CLI"
    exit 1
}

rm argocd-linux-amd64 || {
    echo "error: failure removing file: /usr/local/bin/argocd/argocd-linux-amd64 "
    exit 1
}

# Get the initial password to login argocd
argocd admin initial-password -n argocd | head -n 1 > password.txt

# Expose the ArgoCD server on port 8080
kubectl port-forward svc/argocd-server -n argocd 8080:443

echo "Execution of config_vm.sh finished"
