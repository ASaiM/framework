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
    echo "To do"
else
    echo "Unknow OS"
fi

$src_configure/setup_postgre_db.sh

echo "Configure proftpd"
echo "================="

echo "SQLNamedQuery LookupGalaxyUser SELECT \"email,password,512,512,'"$PWD"/"$galaxy_dir"/database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'" \
    >> $src_configure/proftpd.conf

sudo /usr/local/proftpd --config $PWD/$src_configure/proftpd.conf