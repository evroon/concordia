# Concordia
This project is used to quickly install web applications on my server.

## Services
The following (web) services are installed and configured:
* PostgreSQL
* Munin
* Gitea
* Nextcloud
* FR24
* Selfoss RSS Reader
* Fail2ban
* Homeassistant

## Install
First, rename `sample.env` to `.env` and fill in the necessary values. Then, start the `setup.sh` script:

```bash
git clone git@github.com:evroon/concordia.git
cd concordia
./setup.sh
```
