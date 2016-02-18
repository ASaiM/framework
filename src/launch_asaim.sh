#!/bin/bash
. src/misc.sh

$src_prepare/launch_galaxy.sh

echo "==================================="
echo "Wait until http://$host:$port is up"
echo "----------------------------------------"
echo "Warning: if more than 10 lines of points"
echo "are written, there may be an issue with"
echo "Galaxy. You can check"
echo "$galaxy_dir/paster.log file for errors"
until $(curl --output /dev/null --silent --head --fail http://$host:$port); do
    printf '.'
    sleep 1
done
echo "==================================="
echo ""

echo "Populate with tools and workflows"
echo "================================="
$src_prepare/populate_galaxy.sh
echo ""

echo "Populate with databases"
echo "======================="
$src_prepare/prepare_databases.sh
echo ""

