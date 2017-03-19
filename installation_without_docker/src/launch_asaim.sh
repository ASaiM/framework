#!/usr/bin/env bash
. src/misc.sh

$src_prepare/launch_galaxy.sh --daemon

wait_until_up $port $galaxy_dir/paster.log

echo "Populate with tools"
echo "==================="
$src_prepare/populate_galaxy.sh
echo ""

echo "Populate with databases"
echo "======================="
$src_prepare/prepare_databases.sh
echo ""

