#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

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

apt install -y python3.11-dev build-essential

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



VENV_PATH="/opt/python"

if [ ! -d "$VENV_PATH" ]; then
    apt update && apt install -y python3-venv
    python3 -m venv $VENV_PATH
fi

rm -f /usr/local/bin/python
rm -f /usr/local/bin/pip
rm -f /usr/local/bin/python3
rm -f /usr/local/bin/pip3
ln -sf $VENV_PATH/bin/python3 /usr/local/bin/python
ln -sf $VENV_PATH/bin/python3 /usr/local/bin/python3
ln -sf $VENV_PATH/bin/pip3 /usr/local/bin/pip
ln -sf $VENV_PATH/bin/pip3 /usr/local/bin/pip3
export PATH="/usr/local/bin:$PATH"
hash -d pip 2>/dev/null
hash -d pip3 2>/dev/null
hash -d python 2>/dev/null
hash -d python3 2>/dev/null
hash -r

pip3 install -r ${rootPath}/requirements.txt --no-cache-dir
pip install --upgrade pip setuptools wheel


cd ${rootPath} && pip3pip3 install -r ${rootPath}/requirements.txt --no-cache-dir

# pip3 install flask-caching==1.10.1
# pip3 install mysqlclient

if [ ! -f ${rootPath}/bin/activate ];then
    cd ${rootPath} && python3 -m venv .
    cd ${rootPath} && source ${rootPath}/bin/activate
else
    cd ${rootPath}/panel && source ${rootPath}/bin/activate
fi

pip install --upgrade pip
pip3 install --upgrade setuptools
cd ${rootPath} && pip3 install -r ${rootPath}/requirements.txt --no-cache-dir

echo "lib ok!"
# pip3 install flask-caching==1.10.1
# pip3 install mysqlclient
