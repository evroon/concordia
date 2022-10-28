#!/bin/bash

SELFOSS_VERSION=$(get_latest_github_release --repo "fossar/selfoss")
SELFOSS_VERSION_CURRENT=$(sed -n "s/^SELFOSS=\(.*\).*$/\1/p" ${CONCORDIA_DIR}/versions.env)

if [ "$SELFOSS_VERSION" == "$SELFOSS_VERSION_CURRENT" ]; then
    echo "Selfoss is up-to-date (version: $SELFOSS_VERSION)"
    exit 0
fi

SELFOSS_RELEASE="https://github.com/fossar/selfoss/releases/download/$SELFOSS_VERSION/selfoss-$SELFOSS_VERSION.zip"

cd ${SELFOSS_DIR}
sudo wget ${SELFOSS_RELEASE} -O selfoss.zip
sudo unzip -qo selfoss.zip
sudo rm selfoss.zip
sudo chown www-data:www-data -R ${SELFOSS_DIR}

sudo chmod -R 744 data
sudo chown www-data:www-data ${SELFOSS_DIR}/config.ini

sed -i "s/SELFOSS=.*/SELFOSS=$SELFOSS_VERSION/g" ${CONCORDIA_DIR}/versions.env
