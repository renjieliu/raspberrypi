############################# Dockerfile #############################

FROM ubuntu:18.04

RUN apt-get update && \
        apt-get install -y nano curl locate wget net-tools iputils-ping sudo git  && \
        apt-get install -y libx11-dev libxkbfile-dev make gcc g++ pkg-config  && \
        curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -  && \
        apt install -y nodejs  && \
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# ENV NVM_DIR ~/.nvm

RUN     npm install --global yarn && \
        git clone https://github.com/eclipse-theia/theia && \
        cd theia/  && \
        yarn

CMD ["bash", "'cd /theia/examples/browser && yarn run start --hostname 0.0.0.0'"]


#######################################################################


docker run -tidp 3000:3000 liurenjie/theia:tag_name /bin/bash -c 'cd /theia/examples/browser && yarn run start --hostname 0.0.0.0'


apt-get update && \
apt-get install nano curl locate wget net-tools iputils-ping sudo git  && \
apt-get install libx11-dev libxkbfile-dev make gcc g++ pkg-config  && \
curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -  && \
apt install nodejs  && \
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash && \
export NVM_DIR="$HOME/.nvm" && \
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"   && \ # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"   && \ # This loads nvm bash_completion
nvm --version && \
npm install --global yarn && \
git clone https://github.com/eclipse-theia/theia && \
cd theia/  && \
yarn && \
cd examples/browser && \
yarn run start --hostname 0.0.0.0



