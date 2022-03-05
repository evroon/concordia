#!/bin/bash

# Install ansible
sudo apt install ansible
sudo ansible-playbook -e @secrets.enc ansible/build.yml

if [ ! -f versions.env ]; then
    cat > versions.env << EOF
GITEA=Not Installed
PIAWARE=Not Installed
DOCKER_COMPOSE=Not Installed
SELFOSS=Not Installed
EOF
fi

./build.sh
