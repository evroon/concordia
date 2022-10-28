#!/bin/bash


if cd ${NS_API_DIR}; then
    sudo -Hu munin git pull;
else
    sudo mkdir -p ${NS_API_DIR}
    sudo chown -R munin:munin ${NS_API_DIR}
    sudo -Hu munin git clone https://github.com/evroon/ns-api-python ${NS_API_DIR};
    sudo -Hu munin pip3 install -r ${NS_API_DIR}/requirements.txt
    sudo echo "API_KEY=${API_KEY}" >> ${NS_API_DIR}/.env
fi
