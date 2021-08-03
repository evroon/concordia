cd ~

PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    wget curl python3 python3-pip git make htop tmux \
    docker docker-compose uidmap \
    munin libcgi-fast-perl libapache2-mod-fcgid \
    postgresql postgresql-contrib postgresql-client pgpdump \
    php php-gd php-mbstring php-common php-pgsql php-imagick php-xml php-curl php-tidy php-zip npm \
    certbot python3-certbot-apache libcgi-fast-perl libapache2-mod-php libapache2-mod-fcgid \
    mailutils msmtp msmtp-mta


# ssh-keygen -t ed25519

# Prepare files for installation
WORK_DIR=$(pwd)
TMP_DIR=$(mktemp -d)
echo -e "${PURPLE}Using temporary directory: $TMP_DIR/concordia${NC}"

# Clone repository
cd $TMP_DIR
git clone -q https://github.com/evroon/concordia
REPO_DIR=$TMP_DIR/concordia
cd $REPO_DIR

git checkout feature-rpi

python3 -m pip install -r requirements.txt

cp $WORK_DIR/.env ./
sudo cp .env /root/.env
python3 build.py $REPO_DIR

./install.sh

# rm -rf $TMP_DIR
