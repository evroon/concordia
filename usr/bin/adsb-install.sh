#!/bin/bash

# See: https://discussions.flightaware.com/t/how-to-make-piaware-compatible-with-fr24feed/54045/6
#sudo bash -c "$(wget -O - https://repo-feed.flightradar24.com/install_fr24_rpi.sh)"
sudo dpkg --purge dump1090-mutability

PIAWARE_VERSION=$(get_latest_github_release --tags --repo "flightaware/piaware")
PIAWARE_VERSION="${PIAWARE_VERSION:1}"
PIAWARE_VERSION_CURRENT=$(sed -n "s/^PIAWARE=\(.*\).*$/\1/p" ${CONCORDIA_DIR}/versions.env)

if [ "$PIAWARE_VERSION" == "$PIAWARE_VERSION_CURRENT" ]; then
    echo "PiAware is up-to-date (version: $PIAWARE_VERSION)"
else
    # See: https://discussions.flightaware.com/t/piaware-v-3-7-1-on-debian-10-0-buster-amd64-intel-pc/52414/4
    sudo apt update
    sudo wget "https://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_" "$PIAWARE_VERSION" "_all.deb"
    sudo dpkg -i "piaware-repository_" "$PIAWARE_VERSION" "_all.deb"
    sudo apt-get update

    sudo apt-get install -y piaware

    sed -i "s/PIAWARE=.*/PIAWARE=$PIAWARE_VERSION/g" ${CONCORDIA_DIR}/versions.env
fi

sudo systemctl restart piaware fr24feed

sudo apt-get install -y dump1090-fa
# sudo reboot

wget -O ${PIAWARE_CSV_PATH} https://github.com/flightaware/dump1090/blob/master/tools/flightaware-20200924.csv.xz?raw=true
unxz ${PIAWARE_CSV_PATH}

# Fetch VirtualRadar SQLite db.
sudo touch ${VIRTUALRADAR_SQLITE_DB_PATH}.gz
sudo chown pi:pi ${VIRTUALRADAR_SQLITE_DB_PATH}.gz

if [ ! -f ${VIRTUALRADAR_SQLITE_DB_PATH}.gz ]; then
    wget -O ${VIRTUALRADAR_SQLITE_DB_PATH}.gz https://www.virtualradarserver.co.uk/Files/StandingData.sqb.gz
    sudo gunzip -f ${VIRTUALRADAR_SQLITE_DB_PATH}.gz
fi
