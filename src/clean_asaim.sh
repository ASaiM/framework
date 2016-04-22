#!/usr/bin/env bash
. src/misc.sh

echo "Remove local galaxy dir..."
echo "=========================="
rm -rf $galaxy_dir
echo ""

echo "Remove local shed dir..."
echo "========================"
rm -rf $shed_dir
echo ""

echo "Stop FTP server..."
echo "=================="
sudo kill -TERM `sudo cat $lib_dir/proftpd/var/proftpd.pid`

echo "Drop database and user..."
echo "========================="
$src_configure/clean_postgres_db.sh