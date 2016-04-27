#!/usr/bin/env bash
. src/misc.sh

echo "Stop FTP server..."
echo "=================="
sudo kill -TERM `sudo cat $lib_dir/proftpd/var/proftpd.pid`
echo ""

echo "Drop database and user..."
echo "========================="
$src_configure/clean_postgres_db.sh
echo ""

echo "Remove local lib dir with Galaxy, proftpd, ansible playbook..."
echo "=============================================================="
rm -rf $lib_dir
echo ""
