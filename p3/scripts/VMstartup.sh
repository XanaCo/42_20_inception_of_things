#!bin/bash

# RUN on root or do this before!
# sudo usermod -aG sudo vboxuser
# su vboxuser

# Install VSCode
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update -y
sudo apt-get install code -y

#Install curl
sudo apt-get install curl -y

# Install git
sudo apt-get install git

# Make aliases
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

# Create ssh public key
ssh-keygen -t ed25519 -C "ancolmen@student.42.fr"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
