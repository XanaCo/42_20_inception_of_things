sudo apt-get update
sudo apt-get install curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip $1 --write-kubeconfig-mode=644" sh -
sleep 10

kubectl create configmap app1 --from-file '/vagrant/app1/index.html'
kubectl apply -f '/vagrant/app1/app1.yaml'

kubectl create configmap app2 --from-file '/vagrant/app2/index.html'
kubectl apply -f '/vagrant/app2/app2.yaml'

kubectl create configmap app3 --from-file '/vagrant/app3/index.html'
kubectl apply -f '/vagrant/app3/app3.yaml'

