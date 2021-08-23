#!/bin/bash

cd ${DOCKER_COMPOSE_DIR}

sudo docker pull lissy93/dashy:arm32v7
sudo docker pull homeassistant/home-assistant:stable
sudo docker pull itzg/minecraft-server
sudo docker pull osixia/openldap:1.5.0
sudo docker pull louislam/uptime-kuma
sudo docker pull gotify/server

sudo docker stop homeassistant

sudo docker-compose up -d --force-recreate
