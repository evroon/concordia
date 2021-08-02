cd ~

# Install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    wget curl python3 python3-pip git make htop tmux \
    docker docker-compose uidmap \
    munin libcgi-fast-perl libapache2-mod-fcgid \
    postgresql postgresql-contrib postgresql-client pgpdump \
    php php-gd php-mbstring php-common php-pgsql php-imagick php-xml php-curl php-tidy php-zip npm \
    certbot python3-certbot-apache libcgi-fast-perl libapache2-mod-php libapache2-mod-fcgid


# ssh-keygen -t ed25519

# # Install docker rootless
# curl -fsSL https://get.docker.com/rootless | sh

# cat >> ~/.bashrc <<EOL
# # Docker
# export PATH=/home/azure/bin:$PATH
# export DOCKER_HOST=unix:///run/user/1000/docker.sock
# EOL

# Prepare files for installation
WORK_DIR=$(pwd)
TMP_DIR=$(mktemp -d)
echo "Using temporary directory:" $TMP_DIR

# Clone repository
cd $TMP_DIR
git clone -q https://github.com/evroon/concordia
REPO_DIR=$TMP_DIR/concordia
cd $REPO_DIR

git checkout feature-rpi

python3 -m pip install -r requirements.txt

cp $WORK_DIR/.env ./
sudo cp .env ~/
python3 build.py $REPO_DIR

./install.sh

# rm -rf $TMP_DIR
