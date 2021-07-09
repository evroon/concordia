# Move files to correct locations
sudo mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR} ${DOCKER_COMPOSE_DIR} ${HOME_ASSISTENT_DIR}/config
# sudo cp etc/apache2/sites-available/* /etc/apache2/sites-available
sudo cp etc/apt/apt.conf.d/* /etc/apt/apt.conf.d
sudo cp home/.gitconfig ~/
sudo cp docker/* ${DOCKER_COMPOSE_DIR}
sudo cp homeassistent/* ${HOME_ASSISTENT_DIR}/config

# Setup apache2
sudo a2enmod rewrite proxy
sudo systemctl restart apache2

# Change cron job
sudo crontab crontab.sh

# Install selfoss
cd ${SELFOSS_DIR}
sudo chown www-data:www-data ${SELFOSS_DIR}
sudo -Hu www-data git clone ${SELFOSS_REPO} ${SELFOSS_DIR}
sudo chmod -R 744 ${SELFOSS_DIR}/data
sudo cp selfoss/* ${SELFOSS_DIR}

# Create postgres databases
export PGPASSWORD=${PSQL_PASSWORD}
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "CREATE USER ${SELFOSS_PSQL_USER} WITH PASSWORD '${SELFOSS_PSQL_PASSWORD}';"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "CREATE DATABASE ${SELFOSS_PSQL_DB} WITH OWNER ${SELFOSS_PSQL_USER};"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "ALTER SCHEMA public OWNER TO ${SELFOSS_PSQL_USER};"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "ALTER USER ${SELFOSS_PSQL_USER} WITH SUPERUSER;"

# Set up certbot config file. See: https://gist.github.com/stevenvandervalk/130cba3488611d44390738dd86bb2ea5
sudo mkdir -p /etc/letsencrypt
cat > /tmp/cli.ini <<EOF
# Use a 4096 bit RSA key instead of 2048.
rsa-key-size = 4096
# Set email and domains.
email = ${EMAIL}
domains = ${DOMAIN_NAME},${HOME_ASSISTENT_DOMAIN_NAME},${SELFOSS_DOMAIN_NAME},${MUNIN_DOMAIN_NAME}
# Text interface.
text = True
# No prompts.
non-interactive = True
# Suppress the Terms of Service agreement interaction.
agree-tos = True
# Use the webroot authenticator.
authenticator = webroot
webroot-path = /var/www/html
EOF
sudo mv /tmp/cli.ini /etc/letsencrypt/cli.ini

# Request certificates
sudo certbot certonly

# Start Docker containers.
export PATH=/home/azure/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
cd ${DOCKER_COMPOSE_DIR} && docker-compose up -d


sudo systemctl restart apache2
