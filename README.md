# Concordia
[![ansible](https://github.com/evroon/concordia/actions/workflows/ansible.yml/badge.svg)](https://github.com/evroon/concordia/actions/workflows/ansible.yml)

This project is used to quickly install web applications on my VPS, Raspberry Pi and PCs.

## Services
The following (web) services are installed and configured:
* NGINX
* Letsencrypt
* PostgreSQL
* Munin
* Gitea
* Selfoss RSS Reader
* Fail2ban, sshd, ufw configs
* Homeassistant
* Dashy
* Uptime Kuma
* WEB1090
* Pi-hole
* Selfoss-discord
* Minecraft server
* Msmtp
* btop
* Authelia
* ADSB feeders: FR24, RadarBox, PlaneFinder, PiAware
* Drone
* Grafana, Prometheus, Alertmanager
* Wordpress
* Bracket
* Webdav mount to Nextcloud
* Wireguard VPN with wg-easy

## Setup on Raspberry Pi
First, download Raspbian from [here](https://www.raspberrypi.com/software/operating-systems/).

If you want to start the Pi without connecting a keyboard, mouse and display to it, follow [this guide](https://www.tomshardware.com/reviews/raspberry-pi-headless-setup-how-to,6028.html).
Now, write the image to a USB-stick or an SD-card. Then boot the Pi and you should be able to connect to it via SSH.

## Install
First, rename `sample.env` to `.env` and fill in the necessary values. Then, start the `setup.sh` script:

```bash
git clone git@github.com:evroon/concordia.git
cd concordia
./setup.sh
```

## Build server on Hetzner Cloud
1. Build a server with the configuration from `hetzner.config` (and replace the public SSH key)
1. SSH into the server
1. Run `./setup-concordia.sh`
1. Put the newly generated public SSH key in [Github settings](https://github.com/settings/ssh/new)
1. Make sure `secrets.enc` and `.vault_pass` files are in place
