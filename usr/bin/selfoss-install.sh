#!/bin/bash

cd ${SELFOSS_DIR}
sudo wget ${SELFOSS_RELEASE} -O selfoss.zip
sudo unzip -qo selfoss.zip
sudo rm selfoss.zip
sudo chown www-data:www-data -R ${SELFOSS_DIR}

sudo chmod -R 744 data
sudo chown www-data:www-data ${SELFOSS_DIR}/config.ini
