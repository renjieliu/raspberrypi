#!/bin/bash

# 
# compile and build GCC 9.3 on Rpi, ARMv7 32 bit OS
# run on the latest ubuntu docker image
# the image does not have any existing C / C++ compiler, we need to install them first, in order to compile and build GCC-9

apt-get update;
apt-get install -y nano git wget gcc-8 g++-8 make build-essential libmpc-dev;
mkdir gcc;
cd gcc;
export GCC_VERSION=9.3.0; #The version can be changed here, as needed
wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz;
tar xzvf gcc-${GCC_VERSION}.tar.gz;
mkdir obj.gcc-${GCC_VERSION};
cd gcc-${GCC_VERSION};
./contrib/download_prerequisites;
cd ../obj.gcc-${GCC_VERSION};
../gcc-${GCC_VERSION}/configure --disable-multilib --enable-languages=c,c++ --disable-lto;
make -j $(nproc);
make install ;
echo 'GCC-${GCC_VERSION} has been installed';


