#!/bin/bash 

set -e

sudo chmod +x ./*.sh

sudo ./apt_install.sh

sudo ./download_and_install_apps.sh

sudo -u pi ./config.sh

sudo ./fix_cleanup.sh


echo "Initialization is complete..."






