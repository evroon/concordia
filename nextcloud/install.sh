wget https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.zip
wget https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.zip.md5
wget https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.zip.sha256
wget https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.zip.asc
wget https://nextcloud.com/nextcloud.asc

md5sum -c nextcloud-${NEXTCLOUD_VERSION}.zip.md5 < nextcloud-${NEXTCLOUD_VERSION}.zip
sha256sum -c nextcloud-${NEXTCLOUD_VERSION}.zip.sha256 < nextcloud-${NEXTCLOUD_VERSION}.zip

sudo gpg --import nextcloud.asc
sudo gpg --verify nextcloud-${NEXTCLOUD_VERSION}.zip.asc nextcloud-${NEXTCLOUD_VERSION}.zip

sudo unzip -o nextcloud-${NEXTCLOUD_VERSION}.zip
sudo cp -rf nextcloud /var/www
sudo chown -R www-data:www-data /var/www/nextcloud
