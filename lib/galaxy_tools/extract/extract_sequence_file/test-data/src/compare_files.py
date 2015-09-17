#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse

def readfile(filepath):
    content = []
    with open(filepath, 'r') as open_file:
        for row in open_file.readlines():
            content.append(row[:-1].split(" "))
    return content

def compare_content(expected, observed, comparison):
    if len(expected) != len(observed):
        string = comparison + ': '
        string += 'difference in line number\n'
        string += '\t\texpected:' + str(len(expected)) + '\n'
        string += '\t\tobserved:' + str(len(observed)) + '\n'
        raise ValueError(string)

    for i in range(len(expected)):
        if expected[i] != observed[i]:
            string = comparison + ': '
            string += 'difference in line ' + str(i) + '\n'
            string += '\t' + ' '.join(expected[i]) + '\n'
            string += '\t' + ' '.join(observed[i]) + '\n'
            raise ValueError(string)

def test_file(filepath):
    if not os.path.exists(filepath):
        string = os.path.basename(__file__) + ':' + filepath
        string += ' does not exist'
        raise ValueError(string)

def compare_files(expected_filepath, observed_filepath, comparison):
    test_file(expected_filepath)
    test_file(observed_filepath)

    expected_file_content = readfile(expected_filepath)
    observed_file_content = readfile(observed_filepath)
    compare_content(expected_file_content, observed_file_content, comparison)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--exp_file', required=True)
    parser.add_argument('--obs_file', required=True)
    parser.add_argument('--comparison', required=True)
    args = parser.parse_args()

    compare_files(args.exp_file, args.obs_file, args.comparison)