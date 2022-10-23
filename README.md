# Concordia
[![ansible](https://github.com/evroon/concordia/actions/workflows/ansible.yml/badge.svg)](https://github.com/evroon/concordia/actions/workflows/ansible.yml)

This project is used to quickly install web applications on my server.

## Services
The following (web) services are installed and configured:
* NGINX
* Letsencrypt
* PostgreSQL
* Munin
* Gitea
* Nextcloud
* Selfoss RSS Reader
* Fail2ban
* Homeassistant
* Dashy
* Uptime Kuma
* WEB1090
* Pi-hole
* Selfoss-discord
* Minecraft server
* Msmtp
* btop
* Redis


The following ADS-B feeders are installed:
* FR24
* PlaneFinder
* RadarBox
* PiAware

## Setup on Raspberry Pi
First, download Raspbian from [here](https://www.raspberrypi.com/software/operating-systems/).

If you want to start the Pi without connecting a keyboard, mouse and display to it, create an empty `ssh` file in the `boot` directory to enable SSH.
Furthermore, if you want to connect to WiFi, create a `wpa_supplicant.conf` file in the `boot` directory with the following content:
```
country=NL
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="NETWORK_NAME"
    psk="NETWORK_PASSWORD"
}
```
Now, write the image to a USB-stick or an SD-card. Then boot the Pi and you should be able to connect to it via SSH.

**Note**: You probably want to do the following things before continuing:
* Change the default password
* Run `sudo apt update` and `sudo apt upgrade`, specifically to update the kernel
* Set the correct locale (using `raspi-config`)
* Generate SSH/GPG keys if necessary

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
