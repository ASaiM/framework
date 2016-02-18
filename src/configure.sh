#!/bin/bash
. src/misc.sh

./$src_postgresql/configure_postgres.sh
./$src_proftpd/configure_proftpd.sh