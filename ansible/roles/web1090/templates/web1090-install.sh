#!/bin/bash


if cd ${WEB1090_DIR}; then
    git pull;
else
    sudo mkdir -p ${WEB1090_DIR}
    sudo chown -R root:root ${WEB1090_DIR}
    git clone https://github.com/evroon/web1090 ${WEB1090_DIR};
    sudo ln -s ${WEB1090_DIR}/frontend /var/www/web1090
    pip3 install -r ${WEB1090_DIR}/requirements.txt
fi
