#!/bin/bash

# See: https://discussions.flightaware.com/t/how-to-make-piaware-compatible-with-fr24feed/54045/6
if [ ! -d /lib/fr24 ]; then
    sudo bash -c "$(wget -O - https://repo-feed.flightradar24.com/install_fr24_rpi.sh)"
    sudo systemctl restart fr24feed
    sudo dpkg --purge dump1090-mutability
fi

if [ ! -f /bin/rbfeeder ]; then
    sudo bash -c "$(wget -O - https://apt.rb24.com/inst_rbfeeder.sh)"
fi

if [ ! -f /bin/pfclient ]; then
    wget -O /tmp/pfclient http://client.planefinder.net/pfclient_5.0.161_armhf.deb
    sudo dpkg -i /tmp/pfclient
fi

PIAWARE_VERSION=$(get_latest_github_release --tags --repo "flightaware/piaware")
PIAWARE_VERSION="${PIAWARE_VERSION:1}"
PIAWARE_VERSION_CURRENT=$(sed -n "s/^PIAWARE=\(.*\).*$/\1/p" ${CONCORDIA_DIR}/versions.env)

if [ "$PIAWARE_VERSION" == "$PIAWARE_VERSION_CURRENT" ]; then
    echo "PiAware is up-to-date (version: $PIAWARE_VERSION)"
else
    # See: https://discussions.flightaware.com/t/piaware-v-3-7-1-on-debian-10-0-buster-amd64-intel-pc/52414/4
    sudo apt update
    sudo wget "https://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_${PIAWARE_VERSION}_all.deb"
    sudo dpkg -i "piaware-repository_${PIAWARE_VERSION}_all.deb"
    sudo apt-get update

    sudo apt-get install -y piaware
    sudo systemctl restart piaware

    sed -i "s/PIAWARE=.*/PIAWARE=$PIAWARE_VERSION/g" ${CONCORDIA_DIR}/versions.env
fi


sudo apt-get install -y dump1090-fa

# Fetch ICAO code database
if [ ! -f ${PIAWARE_CSV_PATH} ]; then
    sudo wget -O ${PIAWARE_CSV_PATH}.xz https://github.com/flightaware/dump1090/blob/master/tools/flightaware-20210817.csv.xz?raw=true
    sudo unxz ${PIAWARE_CSV_PATH}.xz
fi

# Fetch VirtualRadar SQLite db.
if [ ! -f ${VIRTUALRADAR_SQLITE_DB_PATH}.gz ]; then
    sudo touch ${VIRTUALRADAR_SQLITE_DB_PATH}.gz
    sudo chown pi:pi ${VIRTUALRADAR_SQLITE_DB_PATH}.gz

    wget -O ${VIRTUALRADAR_SQLITE_DB_PATH}.gz https://www.virtualradarserver.co.uk/Files/StandingData.sqb.gz
    sudo gunzip -f ${VIRTUALRADAR_SQLITE_DB_PATH}.gz
fi
