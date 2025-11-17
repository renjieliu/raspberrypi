#!/bin/bash

# RL 20251020 - Unable to come up with a generic solution to download the latest release from github, as developer uses differnt naming convention for the release 
# some are using *-aarch.tar.gz, some are using zip. Since this file will be run only once, coding once for each app, it's better to check the extension manually when adding to this script.


set -e

arch=$(uname -m)



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




##################################################
########## Microsoft Edit ##########
##################################################

git_repo="https://github.com/microsoft/edit" # change here for the repo 
git_release=$(echo $git_repo | sed 's|https://github.com/||g') # from the git_repo, get the username_repository
tmp_dir_name=$(echo "$git_release"_tmp | sed 's|/|_|g' )  # tmp folder name, like microsoft_edit_tmp

mkdir "/tmp/$tmp_dir_name"
cd "/tmp/$tmp_dir_name"
wget $(curl -s https://api.github.com/repos/$git_release/releases/latest | grep "browser_download_url.*$arch.*zst" | awk 'BEGIN{FS=": "} {print $2}' | tr -d '"')
tar -I zstd -xvf *.zst
sudo cp ./edit /usr/local/bin/msedit
sudo ln -sf /usr/local/bin/msedit /usr/local/bin/me
cd ~
rm -rf "/tmp/$tmp_dir_name"



##################################################
########## bat ##########
##################################################


git_repo="https://github.com/sharkdp/bat" # change here for the repo 
git_release=$(echo $git_repo | sed 's|https://github.com/||g') # from the git_repo, get the username_repository
tmp_dir_name=$(echo "$git_release"_tmp | sed 's|/|_|g' )  # tmp folder name, like microsoft_edit_tmp

mkdir "/tmp/$tmp_dir_name"
cd "/tmp/$tmp_dir_name"
wget $(curl -s https://api.github.com/repos/$git_release/releases/latest | grep "browser_download_url.*$arch.*unknown-linux-gnu.tar.gz" | awk 'BEGIN{FS=": "} {print $2}' | tr -d '"')
tar -zxvf *.tar.gz
rm *.tar.gz
sudo mkdir /usr/local/bin/bat_folder
sudo cp -rf ./bat* /usr/local/bin/bat_folder
sudo ln -sf /usr/local/bin/bat_folder/bat /usr/local/bin/bat
cd ~
rm -rf "/tmp/$tmp_dir_name"




##################################################
########## lazydocker ##########
##################################################

curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash







