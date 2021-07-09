cd ~

# Install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    wget curl python3 python3-pip git make htop \
    docker docker-compose uidmap \
    munin munin-node libcgi-fast-perl libapache2-mod-fcgid \
    postgresql-client pgpdump \
    tmux update-notifier-common \
    php php-gd php-mbstring php-common php-pgsql php-imagick php-xml libapache2-mod-php php-curl php-tidy php-zip npm \
    certbot python3-certbot-apache


# ssh-keygen -t ed25519

# Install docker rootless
curl -fsSL https://get.docker.com/rootless | sh

cat >> ~/.bashrc <<EOL
# Docker
export PATH=/home/azure/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
EOL

# Prepare files for installation
WORK_DIR=$(pwd)
TMP_DIR=$(mktemp -d)
echo "Using temporary directory:" $TMP_DIR

# Clone repository
cd $TMP_DIR
git clone -q https://github.com/evroon/concordia
REPO_DIR=$TMP_DIR/concordia
cd $REPO_DIR

git checkout feature-installation

python3 -m pip install -r requirements.txt

cp $WORK_DIR/.env ./
sudo cp .env ~/
python3 build.py $REPO_DIR

./install.sh

rm -rf $TMP_DIR
