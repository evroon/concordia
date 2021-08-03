#!/bin/bash

sudo chown selfoss:selfoss ${DISCORD_DIR}
if cd ${DISCORD_DIR}; then git pull; else git clone https://github.com/evroon/selfoss-discord ${DISCORD_DIR}; fi
