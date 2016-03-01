#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re
import yaml
from bioblend import galaxy

def get_installed_tool_version(args):
    gi = galaxy.GalaxyInstance(url=args.gi_url, key=args.api_key)
    ts_repositories = gi.toolShed.get_repositories()

    for repo in ts_repositories:
        test = (str(repo['name']) == args.tool_name)
        test &= (not repo['deleted'])
        test &= (str(repo['tool_shed']) == args.tool_shed)
        if test:
            print repo['installed_changeset_revision']
            print repo['owner']

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--tool_name', required=True)
    parser.add_argument('--tool_shed', required=True)
    parser.add_argument('--gi_url', required=True)
    parser.add_argument('--api_key', required=True)
    args = parser.parse_args()

    get_installed_tool_version(args)
