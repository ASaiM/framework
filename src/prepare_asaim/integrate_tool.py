#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re
from bioblend import galaxy
from bioblend import toolshed


def retrieve_changeset_revision(ts_url, name, owner):
    ts = toolshed.ToolShedInstance(url=ts_url)
    ts_repositories = ts.repositories.get_repositories()

    ts_id = None
    for repo in ts_repositories:
        if str(repo['name']) == name and str(repo['owner']) == owner:
            ts_id = repo['id']

    if ts_id == None:
        string = "No repository found for " + name + " (" + owner + ")"
        string += " in toolshed at " + ts_url
        raise ValueError(string)

    return ts.repositories.show_repository_revision(ts_id)['changeset_revision']

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--gi_url', required=True)
    parser.add_argument('--ts_url', required=True)
    parser.add_argument('--api_key', required=True)
    parser.add_argument('--tool_owner', required=True)
    parser.add_argument('--tool_name', required=True)
    parser.add_argument('--tool_panel_section_id', required=True)
    args = parser.parse_args()

    gi = galaxy.GalaxyInstance(url=args.gi_url, key=args.api_key)
    
    changeset_revision = retrieve_changeset_revision(args.ts_url, args.tool_name, 
        args.tool_owner)
    print changeset_revision

    #gi.toolShed.install_repository_revision(ts_url, args.tool_name, args.tool_owner, 
    #    changeset_revision, install_tool_dependencies=True, 
    #    install_repository_dependencies=True, 
    #    tool_panel_section_id=args.tool_panel_section_id)

