#!/bin/sh

B_YELLOW="\033[1;33m"
B_GREEN="\033[1;32m"
B_GREY="\033[1;30m"
B_RED="\033[1;31m"
RESET="\033[0m"

SERVER="cbernazeS"
WORKER="cbernazeSW"

SETGREY="echo -n "${RESET}${B_GREY}""

result_message() {
    if [ $? -eq 0 ]; then
        echo "${B_GREEN}$1${RESET}"
    else
        echo "${B_RED}$2${RESET}"
        exit 1
    fi
}

echo -n "${B_YELLOW}Do you want to check if the two VMs are running? Y/N:"
read yesno
if [ "$yesno" = "y" ] || [ "$yesno" = "Y" ]; then
    $SETGREY
   
    vagrant global-status | grep "${SERVER} " | grep "running"
    result_message "${SERVER} is up and running" "${SERVER} is not running"
   
    $SETGREY
    vagrant global-status | grep "${WORKER}" | grep "running"
    result_message "${WORKER} is up and running" "${WORKER} is not running"
fi

echo -n "${B_YELLOW}Do you want to check cbernazeS? Y/N:"
read yesno
if [ "$yesno" = "y" ] || [ "$yesno" = "Y" ]; then
    $SETGREY
    vagrant ssh cbernazeS
    sudo kubectl get nodes -o wide | grep "cbernazes" | grep "Ready"
    if [ $? -eq 0 ]; then
        echo "${B_GREEN}k3S server cbernazes is ready${RESET}"
    else
        echo "${B_RED}k3S server cbernazes is not ready${RESET}"
    fi

    $SETGREY
    sudo kubectl get nodes -o wide | grep "cbernazesw" | grep "Ready"
    if [ $? -eq 0 ]; then
        echo "${B_GREEN}k3S server cbernazesw is ready${RESET}"
    else
        echo "${B_RED}k3S server cbernazesw is not ready${RESET}"
    fi
    
    $SETGREY
    ip a show eth1
fi