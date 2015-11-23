#!/bin/bash

echo "Configure proftpd"
echo "================="

echo "SQLNamedQuery                   LookupGalaxyUser SELECT \"email,password,512,512,'"$PWD"/lib/galaxy-master/database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'" \
    >> ./src/proftpd/proftpd.conf

sudo /usr/local/proftpd --config $PWD/src/proftpd/proftpd.conf