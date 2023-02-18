#!/bin/bash
set -evo pipefail

# ssh-keygen -t ed25519 -f /home/daniel/.ssh/id_ed25519 -N ""
# echo "Please upload the following public SSH key to https://github.com/settings/ssh/new"
# cat ~/.ssh/id_ed25519.pub

sudo apt install -y ansible git unzip wget

# Install mitogen for Ansible and Ansible galaxy modules
mitogen_dir=/usr/local/ansible
if [ ! -d "$mitogen_dir/mitogen-stable" ]; then
    wget -O /tmp/mitogen.zip https://github.com/dw/mitogen/archive/stable.zip
    sudo mkdir -p $mitogen_dir
    sudo unzip -qo /tmp/mitogen.zip -d $mitogen_dir
fi

sudo ansible-galaxy collection install community.postgresql ansible.posix
