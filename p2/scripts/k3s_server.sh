#!/bin/bash
B_ORANGE="\033[1;34m"
B_YELLOW="\033[1;33m"
B_GREEN="\033[1;32m"
B_GREY="\033[1;30m"
B_RED="\033[1;31m"
RESET="\033[0m"

echo "${B_YELLOW}Executing k3s_server.sh on $(hostname)${RESET}"

RESULT=$(command -v curl)

# Checking if curl is already on the vm, then installing it if it is not
if [ -n "$RESULT" ]; then
    echo "${B_ORANGE}curl is already installed${RESET}"
else
    echo "${B_ORANGE}curl isn't installed yet${RESET}"
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install curl -y
    echo "${B_GREEN}curl is now installed${RESET}"
fi

# Installing k3s in server mode
if k3s --version;then
    echo "${B_ORANGE}k3s is already installed${RESET}"
else
    if export INSTALL_K3S_EXEC="--node-ip=192.168.56.110"; then
        echo "${B_GREEN}INSTALL_K3S_EXEC set as expected${RESET}"
    else
        echo "${B_RED}error setting INSTALL_K3S_EXEC${RESET}"
        exit 1
    fi

    if curl -sfL https://get.k3s.io | sh -; then
        echo "${B_GREEN}K3s Server Installed!${RESET}"
    else
        echo "${B_RED}error installing K3s Server${RESET}"
        exit 1
    fi
fi

CONFIG_DIR="/vagrant/config"

apps=("app-one:app1" "app-two:app2" "app-three:app3")

# Creating all the configmaps needed for our pods
create_configmaps() {
    for app in "${apps[@]}"; do
        app_name="${app%%:*}"
        app_short="${app##*:}"

        html_file="$CONFIG_DIR/$app_short/index.html"
        if [ -f "$html_file" ]; then
            echo "${B_YELLOW}ConfigMap creation for $app_short${RESET}"
            sudo kubectl create configmap "$app_name-html" --from-file="$html_file" || {
                echo "${B_RED}ConfigMap creation failed for $app_short${RESET}"
                exit 1
            }
        else
            echo "${B_RED}$app_short : $html_file not found${RESET}"
            exit 1
        fi
        echo "${B_GREEN}ConfigMap successfully created for $app_short${RESET}"
    done
}

# Creation of all our deployments
apply_yaml_files() {
    for app in "${apps[@]}"; do
        app_name="${app%%:*}"
        app_short="${app##*:}"
        yml_file="$CONFIG_DIR/$app_short/$app_short.yml"
        if [ -f "$yml_file" ]; then
            echo "${B_YELLOW}Creation of $app_short${RESET}"
            sudo kubectl apply -f "$yml_file" || {
                echo "${B_RED}error during the creation of $app_short${RESET}"
                exit 1
            }
            echo 
        else
            echo "${B_RED}$app_short : $yml_file not found${RESET}"
            exit 1
        fi
        echo "${B_GREEN}$app_short successfully created${RESET}"
    done
}

create_configmaps
apply_yaml_files

# sudo kubectl create configmap app-one-html --from-file=/vagrant/config/app1/index.html
# sudo kubectl create configmap app-two-html --from-file=/vagrant/config/app2/index.html
# sudo kubectl create configmap app-three-html --from-file=/vagrant/config/app3/index.html
# sudo kubectl apply -f /vagrant/config/app1/app1.yml
# sudo kubectl apply -f /vagrant/config/app2/app2.yml
# sudo kubectl apply -f /vagrant/config/app3/app3.yml

echo "${B_YELLOW}Finished executing k3s_server.sh on $(hostname)${RESET}"
