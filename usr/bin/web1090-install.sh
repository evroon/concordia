#!/bin/bash


if cd ${WEB1090_DIR}; then
    git pull;
else
    sudo mkdir -p ${WEB1090_DIR}
    sudo chown -R pi:pi ${WEB1090_DIR}
    git clone https://github.com/evroon/web1090 ${WEB1090_DIR};
    pip3 install -r ${WEB1090_DIR}/requirements.txt
fi
