#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import copy

def simplify_table(args):
    if not os.path.exists(args.input):
        string = os.path.basename(__file__) + ': '
        string += args.input + ' does not exist'
        raise ValueError(string)

    with open(args.input,"r") as input_file:
        with open(args.output, "w") as output_file:
            for row in input_file.readlines():
                if row.find('|') == -1:
                    output_file.write(row)


########
# Main #
########
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()

    simplify_table(args)
