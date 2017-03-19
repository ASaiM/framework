#!/usr/bin/env bash

/usr/bin/download_databases
/usr/bin/startup &
sleep 60
python /usr/bin/launch_data_managers.py