# Install dependencies
#sudo apt update && sudo apt upgrade
sudo apt install \
    wget curl python3 python3-pip certbot git make htop \
    docker docker-compose uidmap \
    munin munin-node libcgi-fast-perl libapache2-mod-fcgid \
    postgresql postgresql-contrib postgresql-client pgpdump \
    tmux update-notifier-common php7.4

python3 -m pip install -r requirements.txt

# ssh-keygen -t ed25519

# Install docker rootless
#curl -fsSL https://get.docker.com/rootless | sh

#cat >> ~/.bashrc <<EOL
## Docker
#export PATH=/home/azure/bin:$PATH
#export DOCKER_HOST=unix:///run/user/1000/docker.sock
#EOL


# Prepare files for installation
WORK_DIR=$(pwd)

TMP_DIR=$(mktemp -d)
echo "using temporary directory:" $TMP_DIR

cd $TMP_DIR
git clone -q https://github.com/evroon/concordia
REPO_DIR=$TMP_DIR/concordia
cd $REPO_DIR

git checkout feature-installation

cp $WORK_DIR/.env ./
python3 build.py $REPO_DIR

./install.sh
