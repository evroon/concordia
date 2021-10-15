#!/bin/bash


if cd ${WEB1090_DIR}; then
    sudo -Hu www-data git pull;
else
    sudo mkdir -p ${WEB1090_DIR}
    sudo chown -R www-data:www-data ${WEB1090_DIR}
    sudo -Hu www-data git clone https://github.com/evroon/web1090 ${WEB1090_DIR};
    sudo -Hu www-data pip3 install -r ${WEB1090_DIR}/requirements.txt
fi
