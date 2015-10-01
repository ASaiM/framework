#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse

def get_file_content(filepath):
    file_content = ''
    with open(filepath, 'r') as input_file:
        file_content = input_file.read()
    return file_content

def concatenate_files(args):
    with open(args.output_file, 'w') as output_file:
        output_file.write(get_file_content(args.input_file_1))
        output_file.write(get_file_content(args.input_file_2))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_file_1', required=True)
    parser.add_argument('--input_file_2', required=True)
    parser.add_argument('--output_file', required=True)
    args = parser.parse_args()

    concatenate_files(args)