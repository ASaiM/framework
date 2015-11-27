#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import copy
import operator
import re

def transform_column(args):
    with open(args.input_file,'r') as input_file:
        with open(args.output_file,'w') as output_file:
            column_id = int(args.column_id)-1
            for line in input_file.readlines():
                split_line = line[:-1].split('\t')

                regex_output = re.search(args.regular_expression, 
                    split_line[column_id])
                if regex_output != None:
                    split_line[column_id] = regex_output.groups()[0]

                output_file.write('\t'.join(split_line) + '\n')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_file', required=True)
    parser.add_argument('--column_id', required=True)
    parser.add_argument('--regular_expression', required=True)
    parser.add_argument('--output_file', required=True)
    args = parser.parse_args()
    transform_column(args)