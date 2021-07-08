# Move files to correct locations
sudo mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR}
sudo cp etc/apache2/sites-available/* /etc/apache2/sites-available
sudo cp home/.* ~/
sudo cp psql/* /var/lib/concordia
sudo cp selfoss/* ${CONCORDIA_DIR}

# Change cron job
sudo crontab crontab.sh

cd ~
rm -rf $TMP_DIR

# Install selfoss
cd ${SELFOSS_DIR}
sudo -Hu www-data git clone ${SELFOSS_REPO} ${SELFOSS_DIR}

# Create postgres databases
export PGPASSWORD=${PSQL_PASSWORD}
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "CREATE USER ${SELFOSS_PSQL_USER} WITH PASSWORD '${SELFOSS_PSQL_PASSWORD}';"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "CREATE DATABASE ${SELFOSS_PSQL_DB} WITH OWNER ${SELFOSS_PSQL_USER};"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "ALTER SCHEMA public OWNER TO ${SELFOSS_PSQL_USER};"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "ALTER USER ${SELFOSS_PSQL_USER} WITH SUPERUSER;"

# Request certificates
sudo certbot -d ${DOMAIN_NAME},${HOME_ASSISTENT_DOMAIN_NAME},${SELFOSS_DOMAIN_NAME},${MUNIN_DOMAIN_NAME}

cd ${PSQL_DIR} && docker-compose up -d
cd ${HOME_ASSISTENT_DIR} && docker-compose up -d
