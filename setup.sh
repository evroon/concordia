#!/bin/bash

# Install ansible
sudo apt install ansible
sudo ansible-galaxy collection install community.postgresql

# Run build playbook
sudo ansible-playbook -e @ansible/secrets.ci.yml -e @ansible/inventory.yml -e @ansible/installed_versions.yml ansible/build.yml
