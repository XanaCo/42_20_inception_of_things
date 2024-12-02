sudo apt-get update
sudo apt-get install curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip $1 --write-kubeconfig-mode=644" sh -

echo "Sleeping for 10 seconds to wait for k3s to start"
sleep 10

sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
