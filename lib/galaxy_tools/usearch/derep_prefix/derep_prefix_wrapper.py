#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

def launch_derep_prefix(args):
    command = args.src_dir + '/tools/usearch/usearch8.1.1756_'

    if args.os == 'linux':
        command += 'i86linux32'
    elif args.os == 'mac':
        command += 'i86osx32'
    elif args.os == 'window':
        command += 'win32.exe'
    else:
        string = 'Unknown os', args.os
        raise ValueError(string)

    command += ' -derep_prefix'
    command += ' ' + args.input_sequence_file
    command += ' -fastaout ' + args.output_file

    if args.size_annotation == 'yes':
        command += ' -sizeout'

    if args.min_unique_size != None :
        command += ' -minuniquesize ' + args.min_unique_size
    
    if args.min_seq_length != None:
        command += ' -minseqlength ' + args.min_seq_length

    if args.relabel != None:
        command += ' -relabel ' + args.relabel

    if args.conserve_cluster_nb != None:
        command += ' -topn ' + args.conserve_cluster_nb

    os.system(command)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--input_sequence_file', required=True)
    parser.add_argument('--output_file', required=True)
    parser.add_argument('--size_annotation', required=True)
    parser.add_argument('--min_unique_size')
    parser.add_argument('--min_seq_length')
    parser.add_argument('--relabel')
    parser.add_argument('--conserve_cluster_nb')
    parser.add_argument('--os', required=True)
    args = parser.parse_args()

    launch_derep_prefix(args)