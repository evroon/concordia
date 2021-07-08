# Move files to correct locations
sudo mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR} ${DOCKER_DIR} ${HOME_ASSISTENT_DIR}/config
sudo cp etc/apache2/sites-available/* /etc/apache2/sites-available
sudo cp home/.gitconfig ~/
sudo cp selfoss/* ${CONCORDIA_DIR}
sudo cp docker/* ${DOCKER_DIR}
sudo cp homeassistent/* ${HOME_ASSISTENT_DIR}/config

# Change cron job
sudo crontab crontab.sh

cd ~
rm -rf $TMP_DIR

# Install selfoss
cd ${SELFOSS_DIR}
sudo chown www-data:www-data ${SELFOSS_DIR}
sudo -Hu www-data git clone ${SELFOSS_REPO} ${SELFOSS_DIR}

# Create postgres databases
export PGPASSWORD=${PSQL_PASSWORD}
sudo -u ${PSQL_USER} psql -c "CREATE USER ${SELFOSS_PSQL_USER} WITH PASSWORD '${SELFOSS_PSQL_PASSWORD}';"
sudo -u ${PSQL_USER} psql -c "CREATE DATABASE ${SELFOSS_PSQL_DB} WITH OWNER ${SELFOSS_PSQL_USER};"
sudo -u ${PSQL_USER} psql -c "ALTER SCHEMA public OWNER TO ${SELFOSS_PSQL_USER};"
sudo -u ${PSQL_USER} psql -c "ALTER USER ${SELFOSS_PSQL_USER} WITH SUPERUSER;"

# Request certificates
# sudo certbot -d ${DOMAIN_NAME},${HOME_ASSISTENT_DOMAIN_NAME},${SELFOSS_DOMAIN_NAME},${MUNIN_DOMAIN_NAME}

cd ${DOCKER_DIR} && docker-compose up -d
