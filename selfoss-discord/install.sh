#!/bin/bash

sudo chown www-data:www-data ${DISCORD_DIR}

if cd ${DISCORD_DIR}; then
    git pull;
else
    sudo -Hu www-data git clone https://github.com/evroon/selfoss-discord ${DISCORD_DIR};
fi
