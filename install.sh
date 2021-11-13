# Move files to correct locations
sudo mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DOCKER_COMPOSE_DIR} ${HOME_ASSISTANT_DIR}/config
sudo cp usr/bin/* /usr/bin
sudo cp lib/systemd/system/* /lib/systemd/system
sudo cp -r etc/* /etc
sudo cp home/.gitconfig ~/
sudo cp docker/* ${DOCKER_COMPOSE_DIR}
sudo cp homeassistant/* ${HOME_ASSISTANT_DIR}/config
sudo cp selfoss/config.ini ${SELFOSS_DIR}
sudo cp nextcloud/config.php ${NEXTCLOUD_DIR}/config

# Setup Munin
sudo chown munin:munin ${MUNIN_DIR}
sudo cp munin/munin.conf /etc/munin/munin.conf
sudo cp munin/munin-node /etc/munin/plugin-conf.d/munin-node
sudo cp munin/usr/share/munin/plugins/* /usr/share/munin/plugins

sudo ln -sf /usr/share/munin/plugins/cert_letsencrypt /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/dump1090_aircraft /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/postgres_backup /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/piaware* /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/systemd_failed /etc/munin/plugins
sudo ln -sf /usr/share/munin/plugins/ns_* /etc/munin/plugins

# Set up certbot config file.
sudo mkdir -p /etc/letsencrypt
sudo mv letsencrypt/cli.ini /etc/letsencrypt/cli.ini

# Create postgres databases
cd
export PGPASSWORD=${PSQL_PASSWORD}

create_db () {
    if [ "$( sudo -Hu postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$3'" )" = '1' ]
    then
        echo "Database $3 already exists, skipping..."
    else
        sudo -Hu postgres psql -c "CREATE USER $1 WITH PASSWORD '$2';"
        sudo -Hu postgres psql -c "CREATE DATABASE $3 WITH OWNER $1;"
        sudo -Hu postgres psql -c "ALTER SCHEMA public OWNER TO $1;"
    fi
}

create_db "${SELFOSS_PSQL_USER}" "${SELFOSS_PSQL_PASSWORD}" "${SELFOSS_PSQL_DB}"
create_db "${GITEA_PSQL_USER}" "${GITEA_PSQL_PASSWORD}" "${GITEA_PSQL_DB}"
create_db "${NEXTCLOUD_PSQL_USER}" "${NEXTCLOUD_PSQL_PASSWORD}" "${NEXTCLOUD_PSQL_DB}"
create_db "${FR24_PSQL_USER}" "${FR24_PSQL_PASSWORD}" "${FR24_PSQL_DB}"
create_db "${GOTIFY_PSQL_USER}" "${GOTIFY_PSQL_PASSWORD}" "${GOTIFY_PSQL_DB}"

# Start Docker containers.
cd ${DOCKER_COMPOSE_DIR} && sudo docker-compose up -d

# Create backup directory.
sudo mkdir -p ${PSQL_BACKUP_DIR}
sudo chown postgres:postgres ${PSQL_BACKUP_DIR}

sudo ln -sf /etc/nginx/sites-available/* /etc/nginx/sites-enabled

sudo systemctl restart nginx
sudo systemctl restart munin-node

sudo chown www-data:www-data /var/www

sudo chown www-data:www-data /usr/bin/update-selfoss
sudo chmod 700 /usr/bin/update-selfoss

# Enable services
sudo systemctl enable --now gitea adsb2psql web1090api
sudo systemctl enable nextcloudcron.timer selfoss-update.timer certs-update.timer update-docker-services.timer
sudo systemctl enable postgres-backup@gitea.timer postgres-backup@nextcloud.timer postgres-backup@selfoss.timer postgres-backup@fr24.timer
sudo systemctl enable update-service@gitea.timer update-service@selfoss.timer

# rm -rf $TMP_DIR
