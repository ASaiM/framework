#!/bin/bash

echo "Install dependencies"
echo "===================="

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "OS: MacOSX"
    ./src/dependencies/install_for_mac_os.sh
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo -e "Are you using Debian (Ubuntu, ...) ? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        ./src/dependencies/install_for_debian.sh
    else
        echo -e "Are you using RHEL (Fedore, CentOS, ...) ? (y/n) \c"
        read 
        if [ $REPLY == "y" ]; then
            ./src/dependencies/install_for_rhel.sh
        fi
    fi
else
    echo "Unknow OS"
fi
echo ""

# Proftpd
echo "Install proftp..."
echo "================="
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
cd ../
rm -rf proftpd-1.3.5a/
echo ""

# Pip
echo "Install virtualenv and dependencies with pip..."
echo "==============================================="
sudo pip install --upgrade pip
sudo pip install virtualenv
echo "Install pip requirements..."
if [ ! -d venv ]; then
    virtualenv --no-site-packages venv
fi
source venv/bin/activate
sudo pip install -r requirements.txt
echo ""

# Submodules
echo "Update submodule..."
echo "==================="
git submodule init
git submodule update
