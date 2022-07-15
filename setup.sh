#!/bin/bash

# Run build playbook
cd ansible
ansible-playbook -i hosts build.yml
