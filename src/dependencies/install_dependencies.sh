#!/bin/bash

echo "Install dependencies"
echo "===================="

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "OS: MacOSX"
    ./src/dependencies/install_for_mac_os.sh
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo -e "Are you using Ubuntu? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        ./src/dependencies/install_for_ubuntu.sh
    fi
else
    echo "Unknow OS"
fi

# Proftpd
wget https://github.com/proftpd/proftpd/archive/v1.3.5a.tar.gz
tar -zxvf v1.3.5a.tar.gz | tail
rm v1.3.5a.tar.gz
cd proftpd-1.3.5a/
./configure \
    --prefix=/usr/local/ \
    --disable-auth-file \
    --disable-ncurses \
    --disable-ident \
    --disable-shadow \
    --enable-openssl \
    --with-modules=mod_sql:mod_sql_passwd:mod_sql_postgres
make
sudo make install
rm -rf proftpd-1.3.5a/

# Pip
pip install --upgrade pip
pip install -r requirements.txt