# Move files to correct locations
sudo mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR} ${DOCKER_COMPOSE_DIR} ${HOME_ASSISTANT_DIR}/config
sudo cp usr/bin/* /usr/bin
sudo cp lib/systemd/system/* /lib/systemd/system
sudo cp etc/* /etc
sudo cp etc/msmtprc /etc
sudo cp etc/nginx/sites-available/* /etc/nginx/sites-available
sudo cp etc/apt/apt.conf.d/* /etc/apt/apt.conf.d
sudo cp home/.gitconfig ~/
sudo cp docker/* ${DOCKER_COMPOSE_DIR}
sudo cp homeassistant/* ${HOME_ASSISTANT_DIR}/config
sudo cp selfoss/config.ini ${SELFOSS_DIR}

# Setup Munin
sudo chown munin:munin ${MUNIN_DIR}
sudo cp munin/munin.conf /etc/munin/munin.conf
sudo cp munin/munin-node /etc/munin/plugin-conf.d/munin-node
sudo cp munin/usr/share/munin/plugins/* /usr/share/munin/plugins

sudo ln -sf /usr/share/munin/plugins/cert_letsencrypt /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/dump1090_aircraft /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/postgres_backup /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/piaware* /etc/munin/plugins

# Set up certbot config file.
sudo mkdir -p /etc/letsencrypt
sudo mv letsencrypt/cli.ini /etc/letsencrypt/cli.ini

# Create postgres databases
cd
export PGPASSWORD=${PSQL_PASSWORD}
sudo -Hu postgres psql -c "CREATE USER ${SELFOSS_PSQL_USER} WITH PASSWORD '${SELFOSS_PSQL_PASSWORD}';"
sudo -Hu postgres psql -c "CREATE DATABASE ${SELFOSS_PSQL_DB} WITH OWNER ${SELFOSS_PSQL_USER};"
sudo -Hu postgres psql -c "ALTER SCHEMA public OWNER TO ${SELFOSS_PSQL_USER};"

sudo -Hu postgres psql -c "CREATE USER ${GITEA_PSQL_USER} WITH PASSWORD '${GITEA_PSQL_PASSWORD}';"
sudo -Hu postgres psql -c "CREATE DATABASE ${GITEA_PSQL_DB} WITH OWNER ${GITEA_PSQL_USER};"
sudo -Hu postgres psql -c "ALTER SCHEMA public OWNER TO ${GITEA_PSQL_USER};"

sudo -Hu postgres psql -c "CREATE USER ${NEXTCLOUD_PSQL_USER} WITH PASSWORD '${NEXTCLOUD_PSQL_PASSWORD}';"
sudo -Hu postgres psql -c "CREATE DATABASE ${NEXTCLOUD_PSQL_DB} WITH OWNER ${NEXTCLOUD_PSQL_USER};"
sudo -Hu postgres psql -c "ALTER SCHEMA public OWNER TO ${NEXTCLOUD_PSQL_USER};"

sudo -Hu postgres psql -c "CREATE USER ${FR24_PSQL_USER} WITH PASSWORD '${FR24_PSQL_PASSWORD}';"
sudo -Hu postgres psql -c "CREATE DATABASE ${FR24_PSQL_DB} WITH OWNER ${FR24_PSQL_USER};"
sudo -Hu postgres psql -c "ALTER SCHEMA public OWNER TO ${FR24_PSQL_USER};"

# Start Docker containers.
cd ${DOCKER_COMPOSE_DIR} && sudo docker-compose up -d

# Create backup directory.
sudo mkdir -p ${PSQL_BACKUP_DIR}
sudo chown postgres:postgres ${PSQL_BACKUP_DIR}

sudo ln -sf /etc/nginx/sites-available/* /etc/nginx/sites-enabled
sudo ln -sf /usr/share/web1090/frontend /var/www/web1090

sudo systemctl restart nginx
sudo systemctl restart munin-node

sudo chown www-data:www-data /var/www

sudo chown www-data:www-data /usr/bin/update-selfoss
sudo chmod 700 /usr/bin/update-selfoss

# Enable services
sudo systemctl enable --now gitea adsb2psql web1090api
sudo systemctl enable nextcloudcron.timer selfoss-update.timer certs-update.timer update-docker-services.timer
sudo systemctl enable postgres-backup@gitea.timer postgres-backup@nextcloud.timer postgres-backup@selfoss.timer

# rm -rf $TMP_DIR
