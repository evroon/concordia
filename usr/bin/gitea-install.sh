#!/bin/bash

PLATFORM=amd64
GITEA_VERSION=$(get_latest_github_release --repo "go-gitea/gitea")
GITEA_VERSION="${GITEA_VERSION:1}"
GITEA_VERSION_CURRENT=$(sed -n "s/^GITEA=\(.*\).*$/\1/p" ${CONCORDIA_DIR}/versions.env)

if [ "$GITEA_VERSION" == "$GITEA_VERSION_CURRENT" ]; then
    echo "Gitea is up-to-date (version: $GITEA_VERSION)"
    exit 0
fi
sudo systemctl stop gitea
sudo wget -O /usr/bin/gitea https://dl.gitea.io/gitea/$GITEA_VERSION/gitea-$GITEA_VERSION-linux-$PLATFORM
sudo wget -O /tmp/gitea-$GITEA_VERSION-linux-$PLATFORM.asc https://dl.gitea.io/gitea/$GITEA_VERSION/gitea-$GITEA_VERSION-linux-$PLATFORM.asc
sudo chown git:git /usr/bin/gitea
sudo chmod 755 /usr/bin/gitea

gpg --keyserver keys.openpgp.org --recv 7C9E68152594688862D62AF62D9AE806EC1592E2
gpg --verify /tmp/gitea-$GITEA_VERSION-linux-$PLATFORM.asc /usr/bin/gitea

id 'git' || sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo chown -R git:git /var/lib/gitea/
sudo chmod -R 750 /var/lib/gitea/
sudo mkdir -p /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea

sudo systemctl enable gitea
sudo systemctl start gitea

sed -i "s/GITEA=.*/GITEA=$GITEA_VERSION/g" ${CONCORDIA_DIR}/versions.env
