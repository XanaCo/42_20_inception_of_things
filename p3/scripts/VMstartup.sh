#!bin/bash

sudo usermod -aG sudo vboxuser
su vboxuser
sudo apt-get update -y 
sudo apt-get upgrade 
sudo apt-get install curl -y 
sudo apt-get install git 
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh
ssh-keygen -t ed25519 -C "ancolmen@student.42.fr"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

