# Install dependencies
sudo apt update && sudo apt upgrade
sudo apt install -y \
    wget curl python3 python3-pip certbot git make htop \
    docker docker-compose uidmap \
    munin munin-node libcgi-fast-perl libapache2-mod-fcgid \
    postgresql-client pgpdump \
    tmux update-notifier-common php7.4

python3 -m pip3 install -r requirements.txt

# ssh-keygen -t ed25519

# Install docker rootless
curl -fsSL https://get.docker.com/rootless | sh

cat >> ~/.bashrc <<EOL
# Docker
export PATH=/home/azure/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
EOL


# Prepare files for installation
mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR}
TMP_DIR=$(mktemp -d)

cd $TMP_DIR
git clone https://github.com/evroon/concordia
python3 build.py

# Move files to correct locations
cp etc/apache2/sites-available/* /etc/apache2/sites-available
cp home/* home/.* ~/
cp psql/* /var/lib/concordia
cp selfoss/* ${CONCORDIA_DIR}

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
