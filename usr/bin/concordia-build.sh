#!/bin/bash

cd {{ concordia_dir }}/ansible
touch installed_versions.yml
ansible-playbook -e @secrets.enc -e @inventory.yml -e @installed_versions.yml @?
