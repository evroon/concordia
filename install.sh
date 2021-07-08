# Install dependencies
sudo apt update && sudo apt upgrade
sudo apt install -y \
    wget curl python3 certbot git make \
    docker docker-compose uidmap \
    php7.4 update-notifier-common \
    munin munin-node libcgi-fast-perl libapache2-mod-fcgid \
    postgresql-client pgpdump \
    tmux

# Install docker rootless
curl -fsSL https://get.docker.com/rootless | sh

cat >> ~/.bashrc <<EOL
# Docker
export PATH=/home/azure/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
EOL

mkdir -p ${SELFOSS_DIR} ${MUNIN_DIR} ${DISCORD_DIR}

# Install selfoss
cd ${SELFOSS_DIR}
sudo -Hu www-data git clone ${SELFOSS_REPO} ${SELFOSS_DIR}



# Create databases
export PGPASSWORD=${PSQL_PASSWORD}
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "CREATE USER ${SELFOSS_PSQL_USER} WITH PASSWORD '${SELFOSS_PSQL_PASSWORD}';"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "CREATE DATABASE ${SELFOSS_PSQL_DB} WITH OWNER ${SELFOSS_PSQL_USER};"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "ALTER SCHEMA public OWNER TO ${SELFOSS_PSQL_USER};"
psql -h localhost -p ${PSQL_PORT} -U ${PSQL_USER} -c "ALTER USER ${SELFOSS_PSQL_USER} WITH SUPERUSER;"

sudo certbot -d ${DOMAIN_NAME},${HOME_ASSISTENT_DOMAIN_NAME},${SELFOSS_DOMAIN_NAME},${MUNIN_DOMAIN_NAME}

cd ${PSQL_DIR} && docker-compose up -d
cd ${HOME_ASSISTENT_DIR} && docker-compose up -d
