#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re
import yaml
from bioblend import galaxy

def integrate_workflow_in_gi(args):
    gi = galaxy.GalaxyInstance(url=args.gi_url, key=args.api_key)
    gi.workflows.import_workflow_from_local_path(args.workflow_path)
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--workflow_path', required=True)
    parser.add_argument('--gi_url', required=True)
    parser.add_argument('--api_key', required=True)
    args = parser.parse_args()

    integrate_workflow_in_gi(args)



