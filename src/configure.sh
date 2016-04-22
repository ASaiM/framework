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

cp $PWD/$src_configure/template_proftpd.conf $PWD/$src_configure/proftpd.conf
if ! cat $PWD/$src_configure/proftpd.conf | grep "SQLNamedQuery"; then 
    echo "SQLNamedQuery                   LookupGalaxyUser SELECT \"email,password,"$UID","$GROUPS",'"$PWD"/"$galaxy_dir"/database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'\"" >> $PWD/$src_configure/proftpd.conf
fi

sudo $PWD/$lib_dir/proftpd/proftpd --config $PWD/$src_configure/proftpd.conf -t
sudo $PWD/$lib_dir/proftpd/proftpd --config $PWD/src/configure/proftpd.conf