#!/usr/bin/env bash
. src/misc.sh

get_postgresql_prefix

echo "Configure PostgreSQL"
echo "===================="

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "OS: MacOSX"
    initdb /usr/local/var/postgres -E utf8
    postgres -D /usr/local/var/postgres
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo ""
else
    echo "Unknow OS"
fi

$src_configure/setup_postgre_db.sh

echo "Install and configure proftpd"
echo "============================="

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
cd $current_dir
echo ""

cp $PWD/$src_configure/template_proftpd.conf $PWD/$src_configure/proftpd.conf
if ! cat $PWD/$src_configure/proftpd.conf | grep "SQLNamedQuery"; then 
    echo "SQLNamedQuery                   LookupGalaxyUser SELECT \"email,password,"$UID","$GROUPS",'"$PWD"/"$galaxy_dir"/database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'\"" >> $PWD/$src_configure/proftpd.conf
fi

mkdir -p $PWD/$lib_dir/proftpd/var/proftpd/
touch $PWD/$lib_dir/proftpd/var/proftpd/proftpd.delay
chmod a+w $PWD/$lib_dir/proftpd/var/proftpd/proftpd.delay

sudo $PWD/$lib_dir/proftpd/proftpd --config $PWD/$src_configure/proftpd.conf -t
sudo $PWD/$lib_dir/proftpd/proftpd --config $PWD/$src_configure/proftpd.conf
