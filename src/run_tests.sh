#!/bin/bash
export GALAXY_TEST_UPLOAD_ASYNC=false
export GALAXY_TEST_DB_TEMPLATE=https://github.com/jmchilton/galaxy-downloads/raw/master/db_gx_rev_0127.sqlite

./src/prepare_galaxy.sh run_test

echo "TO DO : Launch tests on toy dataset"

