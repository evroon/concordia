# Move files to correct locations
sudo mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR} ${DOCKER_DIR} ${HOME_ASSISTENT_DIR}/config
sudo cp etc/apache2/sites-available/* /etc/apache2/sites-available
sudo cp etc/apt/apt.conf.d/* /etc/apt/apt.conf.d
sudo cp home/.gitconfig ~/
sudo cp selfoss/* ${CONCORDIA_DIR}
sudo cp docker/* ${DOCKER_DIR}
sudo cp homeassistent/* ${HOME_ASSISTENT_DIR}/config

# Change cron job
sudo crontab crontab.sh

# Install selfoss
cd ${SELFOSS_DIR}
sudo chown www-data:www-data ${SELFOSS_DIR}
sudo -Hu www-data git clone ${SELFOSS_REPO} ${SELFOSS_DIR}
sudo chmod -R 744 ${SELFOSS_DIR}/data

# Create postgres databases
sudo -u ${PSQL_USER} psql -c "CREATE USER ${SELFOSS_PSQL_USER} WITH PASSWORD '${SELFOSS_PSQL_PASSWORD}';"
sudo -u ${PSQL_USER} psql -c "CREATE DATABASE ${SELFOSS_PSQL_DB} WITH OWNER ${SELFOSS_PSQL_USER};"
sudo -u ${PSQL_USER} psql -c "ALTER SCHEMA public OWNER TO ${SELFOSS_PSQL_USER};"
sudo -u ${PSQL_USER} psql -c "ALTER USER ${SELFOSS_PSQL_USER} WITH SUPERUSER;"

# Request certificates
# sudo certbot -d ${DOMAIN_NAME},${HOME_ASSISTENT_DOMAIN_NAME},${SELFOSS_DOMAIN_NAME},${MUNIN_DOMAIN_NAME}

export PATH=/home/azure/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
cd ${DOCKER_DIR} && docker-compose up -d
