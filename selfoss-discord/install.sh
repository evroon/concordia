#!/bin/bash


if cd ${DISCORD_DIR}; then
    git pull;
else
    sudo mkdir -p ${DISCORD_DIR}
    sudo chown -R www-data:www-data ${DISCORD_DIR}
    sudo -Hu www-data git clone https://github.com/evroon/selfoss-discord ${DISCORD_DIR};
    sudo -Hu www-data pip3 install -r ${DISCORD_DIR}/requirements.txt
fi
