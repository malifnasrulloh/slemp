#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

set -e

curPath=`pwd`
rootPath=$(dirname "$curPath")
serverPath=$(dirname "$rootPath")
sourcePath=$serverPath/source/lib
libPath=$serverPath/lib

mkdir -p $sourcePath
mkdir -p $libPath
rm -rf ${libPath}/lib.pl


bash ${rootPath}/scripts/getos.sh
OSNAME=`cat ${rootPath}/data/osname.pl`
VERSION_ID=`cat /etc/*-release | grep VERSION_ID | awk -F = '{print $2}' | awk -F "\"" '{print $2}'`
echo "${OSNAME}:${VERSION_ID}"

if [ "$OSNAME" == "debian" ] || [ "$OSNAME" == "ubuntu" ]; then
    apt install -y python3.11-dev build-essential
fi

# system judge
if [ "$OSNAME" == "macos" ]; then
    brew install libmemcached
    brew install curl
    brew install zlib
    brew install freetype
    brew install openssl
    brew install libzip
elif [ "$OSNAME" == "opensuse" ];then
    echo "opensuse lib"
elif [ "$OSNAME" == "arch" ];then
    echo "arch lib"
elif [ "$OSNAME" == "freebsd" ];then
    echo "freebsd lib"
elif [ "$OSNAME" == "centos" ];then
    echo "centos lib"
elif [ "$OSNAME" == "rocky" ]; then
    echo "rocky lib"
elif [ "$OSNAME" == "fedora" ];then
    echo "fedora lib"
elif [ "$OSNAME" == "alma" ];then
    echo "alma lib"
elif [ "$OSNAME" == "ubuntu" ];then
    echo "ubuntu lib"
elif [ "$OSNAME" == "debian" ]; then
    echo "debian lib"
else
    echo "OK"
fi

if [ "$OSNAME" == "debian" ] || [ "$OSNAME" == "ubuntu" ]; then
    apt update && apt install -y \
    build-essential curl git \
    libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev \
    libsqlite3-dev \
    libffi-dev libncursesw5-dev \
    xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev \
    liblzma-dev ca-certificates
fi

curl https://pyenv.run | bash

cat >> ~/.bashrc << 'EOF'

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"

EOF

source ~/.bashrc

pyenv install 3.11.2
pyenv global 3.11.2

pip install --upgrade pip setuptools wheel virtualenv


cd ${rootPath} && pip3 install -r ${rootPath}/requirements.txt --no-cache-dir

# pip3 install flask-caching==1.10.1
# pip3 install mysqlclient

if [ ! -f ${rootPath}/bin/activate ];then
    cd ${rootPath} && python3 -m venv .
    cd ${rootPath} && source ${rootPath}/bin/activate
else
    cd ${rootPath} && source ${rootPath}/bin/activate
fi

pip install --upgrade pip
pip3 install --upgrade setuptools
pip3 install -r ${rootPath}/requirements.txt --no-cache-dir

echo "lib ok!"
# pip3 install flask-caching==1.10.1
# pip3 install mysqlclient