# See: https://discussions.flightaware.com/t/how-to-make-piaware-compatible-with-fr24feed/54045/6
sudo bash -c "$(wget -O - https://repo-feed.flightradar24.com/install_fr24_rpi.sh)"
sudo dpkg --purge dump1090-mutability

# See: https://discussions.flightaware.com/t/piaware-v-3-7-1-on-debian-10-0-buster-amd64-intel-pc/52414/4
sudo apt update
sudo wget http://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_3.7.1_all.deb
sudo dpkg -i piaware-repository_3.7.1_all.deb
sudo apt-get update

sudo apt-get install -y piaware
sudo systemctl restart piaware fr24feed

sudo apt-get install -y dump1090-fa
# sudo reboot

wget -O ${PIAWARE_CSV_PATH} https://github.com/flightaware/dump1090/blob/master/tools/flightaware-20200924.csv.xz?raw=true
unxz ${PIAWARE_CSV_PATH}

# Fetch VirtualRadar SQLite db.
sudo touch ${VIRTUALRADAR_SQLITE_DB_PATH}.gz
sudo chown pi:pi ${VIRTUALRADAR_SQLITE_DB_PATH}.gz

wget -O ${VIRTUALRADAR_SQLITE_DB_PATH}.gz https://www.virtualradarserver.co.uk/Files/StandingData.sqb.gz
sudo gunzip -f ${VIRTUALRADAR_SQLITE_DB_PATH}.gz
