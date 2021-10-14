# Install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    wget curl python3 python3-pip git make htop tmux pwgen \
    docker-compose uidmap \
    munin libcgi-fast-perl \
    postgresql postgresql-contrib postgresql-client pgpdump \
    php php-gd php-mbstring php-common php-pgsql php-imagick php-xml php-curl php-tidy php-zip \
    certbot python3-certbot-nginx \
    mailutils msmtp msmtp-mta aha

sudo pip3 install docker-compose python-dateutil
python3 -m pip install -r requirements.txt

cat > versions.env << EOF
GITEA=Not Installed
PIAWARE=Not Installed
DOCKER_COMPOSE=Not Installed
SELFOSS=Not Installed
EOF

./build.sh
