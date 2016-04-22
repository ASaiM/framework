#!/usr/bin/env bash
. src/misc.sh

echo "Install dependencies"
echo "===================="

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "OS: MacOSX"
    $src_install_dependencies/install_for_mac_os.sh
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    if cat /etc/*-release | grep "debian"; then
        $src_install_dependencies/install_for_debian.sh
    else
        $src_install_dependencies/install_for_rhel.sh
    fi
else
    echo "Unknow OS"
fi
echo ""

# Proftpd
echo "Install proftp..."
echo "================="
if [[ ! -d $lib_dir ]]; then
    mkdir -p $lib_dir 
fi
current_dir=$PWD

cd $lib_dir

wget https://github.com/proftpd/proftpd/archive/v1.3.5a.tar.gz
tar -zxvf v1.3.5a.tar.gz
rm v1.3.5a.tar.gz
mv proftpd-1.3.5a/ proftpd/
cd proftpd
./configure \
    --prefix=$PWD \
    --disable-auth-file \
    --disable-ncurses \
    --disable-ident \
    --disable-shadow \
    --enable-openssl \
    --with-modules=mod_sql:mod_sql_passwd:mod_sql_postgres
make
make install
cd $current_dir
echo ""
