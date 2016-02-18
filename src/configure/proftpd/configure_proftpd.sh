#!/bin/bash
. src/misc.sh

echo "Configure proftpd"
echo "================="

echo "SQLNamedQuery LookupGalaxyUser SELECT \"email,password,512,512,'"$PWD"/"$galaxy_dir"/database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'" \
    >> ./$src_proftpd/proftpd.conf

sudo /usr/local/proftpd --config $PWD/$src_proftpd/proftpd.conf