sudo apt-get update
apt-get install curl

node_token=$(cat /vagrant/node-token)

curl -sfL https://get.k3s.io | K3S_URL="https://$1:6443" K3S_TOKEN="$node_token" INSTALL_K3S_EXEC="--node-ip $2" sh -
