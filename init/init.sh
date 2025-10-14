#!/bin/bash 

set -e

sudo chmod +x ./*.sh

sudo ./apt_install.sh

sudo ./download_and_install_apps.sh

sudo -u pi ./pi_config.sh

sudo ./fix_cleanup.sh

echo "Initialization complete.."

echo "NOTE: alias the sms_when_job_done from my tech journaling doc"







