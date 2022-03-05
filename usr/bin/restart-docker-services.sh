#!/bin/bash

cd ${DOCKER_COMPOSE_DIR}

sudo docker-compose up -d --force-recreate

sudo docker system prune -f
sudo docker volume prune -f
sudo docker network prune -f
