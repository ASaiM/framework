#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from bioblend import galaxy

def check_job_state(gi, job_id):
    """Check the status of a job in a Galaxy instance

    Returns the status of a job

    gi: GalaxyInstance object of a running Galaxy instance
    job_id: id of the wanted job on the running Galaxy instance
    """
    print("\tjob id: %s" % job_id)
    job_state = gi.jobs.get_state(job_id)
    while job_state != "ok" and job_state != "error":
        print("\tstate: %s" % job_state)
        time.sleep(10)
        job_state = gi.jobs.get_state(job_id)

    if job_state == "ok":
        print("\tstate: done")
        return True
    else:
        print("\tstate: error")
        return False


if __name__ == '__main__':
    url = "http://localhost:80"
    key = "admin"
    gi = galaxy.GalaxyInstance(url=url, key=key)
    #gi = galaxy.GalaxyInstance(url="http://132.230.153.43:8080/", key="admin")

    hist = gi.histories.create_history("Download from data managers")

    # Download database for metaphlan2
    print("Install MetaPhlAn2 database")
    metaphlan2_dm = gi.tools.get_tools(name="MetaPhlAn2 download")[0]
    tool_inputs = {
        "database": "db_v20"
    }
    metaphlan2_dm_exec = gi.tools.run_tool(
        hist['id'],
        metaphlan2_dm['id'],
        tool_inputs)
    check_job_state(gi, metaphlan2_dm_exec["jobs"][0]["id"])

    # Download databases for humann2
    humann2_dm = gi.tools.get_tools(name="HUMAnN2 download")[0]
    ## Nucleotide database: full chocophlan
    print("Install HUMAnN2 nucleotide database")
    tool_inputs = {
        "database": "chocophlan",
        "build": "full"
    }
    humann2_full_chocophlan_dm_exect = gi.tools.run_tool(
        hist['id'],
        humann2_dm['id'],
        tool_inputs)
    check_job_state(gi, humann2_full_chocophlan_dm_exect["jobs"][0]["id"])
    ## Protein database: full uniref90
    print("Install HUMAnN2 protein databases")
    tool_inputs = {
        "database": "uniref",
        "build": "uniref90_diamond"
    }
    humann2_uniref90_exect = gi.tools.run_tool(
        hist['id'],
        humann2_dm['id'],
        tool_inputs)
    check_job_state(gi, humann2_uniref90_exect["jobs"][0]["id"])
    ## Protein database: full uniref50
    tool_inputs = {
        "database": "uniref",
        "build": "uniref50_diamond"
    }
    humann2_uniref50_exect = gi.tools.run_tool(
        hist['id'],
        humann2_dm['id'],
        tool_inputs)
    check_job_state(gi, humann2_uniref50_exect["jobs"][0]["id"])