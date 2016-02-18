#!/bin/bash
. src/misc.sh

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

./$src_postgresql/setup_postgre_db.sh