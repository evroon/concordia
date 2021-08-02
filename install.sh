REPO_DIR=$(pwd)

# Move files to correct locations
sudo mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR} ${DOCKER_COMPOSE_DIR} ${HOME_ASSISTANT_DIR}/config
sudo cp lib/systemd/system/* /lib/systemd/system
sudo cp etc/apache2/sites-available/* /etc/apache2/sites-available
sudo cp etc/apt/apt.conf.d/* /etc/apt/apt.conf.d
sudo cp home/.gitconfig ~/
sudo cp docker/* ${DOCKER_COMPOSE_DIR}
sudo cp homeassistant/* ${HOME_ASSISTANT_DIR}/config

# Install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Setup apache2
sudo a2enmod rewrite proxy ssl fcgid
sudo systemctl restart apache2

# Change cron job
sudo crontab crontab.sh

# Install selfoss
cd ${SELFOSS_DIR}
sudo wget ${SELFOSS_RELEASE} -O selfoss.zip
sudo unzip -qo selfoss.zip
sudo rm selfoss.zip
sudo chown www-data:www-data -R ${SELFOSS_DIR}

sudo chmod -R 744 data
sudo cp $REPO_DIR/selfoss/config.ini ${SELFOSS_DIR}
sudo chown www-data:www-data ${SELFOSS_DIR}/config.ini

# Install Munin
sudo chown munin:munin ${MUNIN_DIR}
sudo cp $REPO_DIR/munin/munin.conf /etc/munin/munin.conf

# Set up certbot config file. See: https://gist.github.com/stevenvandervalk/130cba3488611d44390738dd86bb2ea5
sudo mkdir -p /etc/letsencrypt
sudo mv $REPO_DIR/letsencrypt/cli.ini /etc/letsencrypt/cli.ini

# Request certificates
sudo certbot certonly

# Start Docker containers.
# export PATH=/home/azure/bin:$PATH
# export DOCKER_HOST=unix:///run/user/1000/docker.sock
cd ${DOCKER_COMPOSE_DIR} && sudo docker-compose up -d

# Create postgres databases
export PGPASSWORD=${PSQL_PASSWORD}
sudo -u postgres psql -c "CREATE USER ${SELFOSS_PSQL_USER} WITH PASSWORD '${SELFOSS_PSQL_PASSWORD}';"
sudo -u postgres psql -c "CREATE DATABASE ${SELFOSS_PSQL_DB} WITH OWNER ${SELFOSS_PSQL_USER};"
sudo -u postgres psql -c "ALTER SCHEMA public OWNER TO ${SELFOSS_PSQL_USER};"
sudo -u postgres psql -c "ALTER USER ${SELFOSS_PSQL_USER} WITH SUPERUSER;"


sudo a2ensite 000-default-le-ssl.conf 000-default.conf 001-selfoss.conf 002-home-assistant.conf 003-munin.conf
sudo systemctl restart apache2
sudo systemctl restart munin-node
