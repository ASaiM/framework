#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re
import yaml

def get_revision_number(yaml_content, tool_name):
    for tool in yaml_content['tools']:
        if tool["name"] == tool_name:
            if tool.has_key("revisions"):
                print tool["revisions"][0]

def get_owner(yaml_content, tool_name):
    for tool in yaml_content['tools']:
        if tool["name"] == tool_name:
            print tool['owner']

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--file', required=True)
    parser.add_argument('--tool_name', required=True)
    parser.add_argument('--tool_function', required=True)
    args = parser.parse_args()

    with open(args.file,'r') as yaml_file:
        yaml_content = yaml.load(yaml_file)

    functions = {
        'get_revision_number': get_revision_number,
        'get_owner': get_owner
    }

    functions[args.tool_function](yaml_content, args.tool_name)