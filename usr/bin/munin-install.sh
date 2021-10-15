#!/bin/bash

TMP_DIR=$(mktemp -d)

cd $TMP_DIR
git clone https://github.com/munin-monitoring/contrib.git

cd /etc/munin
sudo cp -r $TMP_DIR/contrib/templates/munstrap/templates .
sudo cp -r $TMP_DIR/contrib/templates/munstrap/static .

# Let Munin regenerate HTML files.
sudo rm -rf /var/www/munin/*
