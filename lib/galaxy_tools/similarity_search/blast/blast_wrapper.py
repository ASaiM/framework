#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--input_sequence_file', required=True)
    parser.add_argument('--db', required=True, action='append')
    args = parser.parse_args()

    print args