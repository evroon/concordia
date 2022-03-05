#!/bin/bash

cd ${DOCKER_COMPOSE_DIR}

sudo docker pull lissy93/dashy
sudo docker pull homeassistant/home-assistant:stable
sudo docker pull itzg/minecraft-server
sudo docker pull osixia/openldap:1.5.0
sudo docker pull louislam/uptime-kuma

sudo docker stop homeassistant

/usr/bin/restart-docker-services.sh
