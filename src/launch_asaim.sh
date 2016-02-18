#!/bin/bash
. src/misc.sh

$src_prepare/launch_galaxy.sh

echo "Wait until http://$host:$port is up"
until $(curl --output /dev/null --silent --head --fail http://$host:$port); do
    printf '.'
    sleep 1
done

echo "Populate with tools and workflows"
echo "================================="
$src_prepare/populate_galaxy.sh

echo "Populate with databases"
echo "======================="
$src_prepare/prepare_databases.sh
echo ""

