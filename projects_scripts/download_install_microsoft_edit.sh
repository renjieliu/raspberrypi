#!/bin/bash

set -e

arch=$(uname -m)

mkdir /tmp/msedit_download_tmp
cd /tmp/msedit_download_tmp
wget $(curl -s https://api.github.com/repos/microsoft/edit/releases/latest | grep "browser_download_url.*$arch.*zst" | awk 'BEGIN{FS=": "} {print $2}' | tr -d '"')
sudo apt install zstd -y
tar -I zstd -xvf *.zst
sudo cp ./edit /usr/local/bin/msedit
sudo ln -s /usr/local/bin/msedit /usr/local/bin/me
cd ~
rm -rf /tmp/msedit_download_tmp



