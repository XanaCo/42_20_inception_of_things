#!/bin/bash
echo "Executing k3s_server.sh on $(hostname)"

result=$(command -v curl)

if [ -n "$result" ]; then
    echo "curl is already installed"
else
    echo "curl isn't installed yet"
    sudo apt-get update
    # sudo apt-get upgrade -y
    sudo apt-get install curl -y
    echo "curl is now installed"
fi

export INSTALL_K3S_EXEC="--node-ip=192.168.56.110"
curl -sfL https://get.k3s.io | sh -

sudo cat /var/lib/rancher/k3s/server/token > /vagrant/server-token

echo "Finished executing k3s_server.sh on $(hostname)"
