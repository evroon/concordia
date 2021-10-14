#!/bin/bash

PLATFORM=armv7
DOCKER_COMPOSE_VERSION=$(get_latest_github_release "docker/compose")
DOCKER_COMPOSE_VERSION="${DOCKER_COMPOSE_VERSION:1}"
DOCKER_COMPOSE_VERSION_CURRENT=$(sed -n "s/^DOCKER_COMPOSE=\(.*\).*$/\1/p" versions.env)

if [ "$DOCKER_COMPOSE_VERSION" == "$DOCKER_COMPOSE_VERSION_CURRENT" ]; then
    echo "Docker Compose is up-to-date (version: $DOCKER_COMPOSE_VERSION)"
    exit 0
fi

sudo curl -L "https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-linux-$PLATFORM" -o /usr/local/bin/docker-compose

sed -i "s/DOCKER_COMPOSE=.*/DOCKER_COMPOSE=$DOCKER_COMPOSE_VERSION/g" versions.env
