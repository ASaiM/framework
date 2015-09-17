#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import copy
import operator

def readfile(filepath):
    content = []
    with open(filepath, 'r') as open_file:
        for row in open_file.readlines():
            content.append(row[:-1].split(" "))
    return content

def compare_content(expected, observed, comparison):
    if len(expected) != len(observed):
        string = comparison + ': '
        string += 'difference in line number'
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

def compare_report_files(expected_filepath, observed_filepath):
    test_file(expected_filepath)
    test_file(observed_filepath)

    expected_file_content = readfile(expected_filepath)
    observed_file_content = readfile(observed_filepath)
    compare_content(expected_file_content[1:], observed_file_content[1:], 
        'Report comparison')   

def compare_output_files(expected_filepath, observed_filepath):
    test_file(expected_filepath)
    test_file(observed_filepath)

    expected_file_content = readfile(expected_filepath)
    observed_file_content = readfile(observed_filepath)
    compare_content(expected_file_content, observed_file_content, 
        'Output comparison')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--exp_report', required=True)
    parser.add_argument('--obs_report', required=True)
    parser.add_argument('--exp_output', required=True)
    parser.add_argument('--obs_output', required=True)
    args = parser.parse_args()

    compare_report_files(args.exp_report, args.obs_report)
    compare_output_files(args.exp_output, args.obs_output)