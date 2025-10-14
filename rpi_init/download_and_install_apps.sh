#!/bin/bash

set -e

arch=$(uname -m)


##################################################
########## Microsoft Edit ##########
##################################################

mkdir /tmp/msedit_download_tmp
cd /tmp/msedit_download_tmp
wget $(curl -s https://api.github.com/repos/microsoft/edit/releases/latest | grep "browser_download_url.*$arch.*zst" | awk 'BEGIN{FS=": "} {print $2}' | tr -d '"')
tar -I zstd -xvf *.zst
sudo cp ./edit /usr/local/bin/msedit
sudo ln -s /usr/local/bin/msedit /usr/local/bin/me
cd ~
rm -rf /tmp/msedit_download_tmp



##################################################
########## YouTube Downloader ##########
##################################################

mkdir /tmp/yt_downloader_tmp
cd /tmp/yt_downloader_tmp
wget $(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest | grep "browser_download_url.*$arch.*zip" | awk 'BEGIN{FS=": "} {print $2}' | grep -v "musl" | sed 's/"//g')
unzip *.zip
sudo rm *.zip
sudo mkdir /usr/local/bin/yt-dlp
sudo cp -r * /usr/local/bin/yt-dlp
sudo ln -s /usr/local/bin/yt-dlp/yt-dlp_linux_$arch /usr/local/bin/yt 
cd ~
rm -rf /tmp/yt_downloader_tmp






