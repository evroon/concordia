#!/bin/bash

TMP_DIR=$(mktemp -d)
cd $TMP_DIR

# Disable all sites except the default.
sudo mv /etc/nginx/sites-enabled/default .
sudo rm /etc/nginx/sites-enabled/*
sudo mv default /etc/nginx/sites-enabled/default

sudo certbot certonly
