#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"
SERVER="ancolmenS"
WORKER="ancolmenSW"
SERVER_NODE="ancolmens"
WORKER_NODE="ancolmensw"

# Function to check the result of the last command
check_result() {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ $1 correct${RESET}"
  else
    echo -e "${RED}✘ $1 wrong${RESET}"
    exit 1
  fi
}

echo "Validating Cluster Setup..."

# Check Server Resources
echo "Checking Server resources..."
vagrant ssh ${SERVER} -c "grep -c processor /proc/cpuinfo | grep 1"
check_result "Server CPU"
vagrant ssh ${SERVER} -c "awk '/MemTotal/ {if (\$2 >= 983000 && \$2 <= 1048576) exit 0; else exit 1}' /proc/meminfo"
check_result "Server Memory (1024MB)"

# Check Worker Resources
echo "Checking Worker resources..."
vagrant ssh ${WORKER} -c "grep -c processor /proc/cpuinfo | grep 1"
check_result "Worker CPU"
vagrant ssh ${SERVER} -c "awk '/MemTotal/ {if (\$2 >= 983000 && \$2 <= 1048576) exit 0; else exit 1}' /proc/meminfo"
check_result "Worker Memory (1024MB)"

# Check Networking
echo "Checking Server IP..."
vagrant ssh ${SERVER} -c "ip addr show eth1 | grep 'inet 192.168.56.110'"
check_result "Server IP Address (192.168.56.110)"
echo "Checking Worker IP..."
vagrant ssh ${WORKER} -c "ip addr show eth1 | grep 'inet 192.168.56.111'"
check_result "Worker IP Address (192.168.56.111)"

# Check k3s Install
echo "Checking if kubectl is installed on Server..."
vagrant ssh ${SERVER} -c "kubectl version"
check_result "kubectl on Server"
echo "Checking if kubectl is installed on Worker..."
vagrant ssh ${WORKER} -c "kubectl version --client"
check_result "kubectl on Worker"

# Check K3s Setup
echo "Checking Nodes on Server..."
vagrant ssh ${SERVER} -c "kubectl get nodes | grep ${SERVER_NODE} | grep 'Ready'"
check_result "Control Plane (Server) Ready"
vagrant ssh ${SERVER} -c "kubectl get nodes | grep ${WORKER_NODE} | grep 'Ready'"
check_result "Node (Worker) Ready"

# Check K3s Status
echo "Checking K3s control plane service status on Server..."
vagrant ssh ${SERVER} -c "sudo systemctl status k3s | grep 'active (running)'"
check_result "K3s control plane active"
echo "Checking K3s agent service status on Worker..."
vagrant ssh ${WORKER} -c "sudo systemctl status k3s-agent | grep 'active (running)'"
check_result "K3s agent active"

# Check K3s Pods
echo "Checking pods in kube-system namespace on Server..."
vagrant ssh ${SERVER} -c "kubectl get pods -n kube-system"
check_result "Pods in kube-system on Server"

# Check K3s Node Port Range
echo "Checking Node Port range availability on Worker..."
vagrant ssh ${WORKER} -c "curl --insecure https://192.168.56.110:6443"
check_result "Node Port range availability on Worker"

echo -e "${GREEN}All tests passed successfully!${RESET}"
