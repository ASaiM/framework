#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse

def launch_fastq_join(args, dirpath, file_format):
    current_directory = os.getcwd()

    command = current_directory + '/trunk/clipper/fastq-join'

    command += ' -p ' + args.max_diff_perc
    command += ' -m ' + args.min_overlap
    if args.smaller_insert == 'yes':
        command += ' -x '

    command += ' ' + args.r1_sequence_file
    command += ' ' + args.r2_sequence_file
    command += ' -o ' + dirpath + '/%.' + file_format
    command += ' > ' + dirpath + '/fastq_join_verbose_output' 

    os.system(command)

def generate_outputs(dirpath, args):
    output_files = os.listdir(dirpath)
    print output_files

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--r1_sequence_file', required=True)
    parser.add_argument('--r2_sequence_file', required=True)
    parser.add_argument('--min_overlap', required=True)
    parser.add_argument('--max_diff_perc', required=True)
    parser.add_argument('--smaller_insert', required=True)
    parser.add_argument('--join_sequence_file', required=True)
    parser.add_argument('--single_R1_sequence_file', required=True)
    parser.add_argument('--single_R2_sequence_file', required=True)
    parser.add_argument('--report', required=True)
    args = parser.parse_args()

    dirpath, R1_filename = os.path.split(os.path.abspath(args.r1_sequence_file))
    dirpath, R2_filename = os.path.split(os.path.abspath(args.r2_sequence_file))

    R1_filename, file_format = R1_filename.split('.')
    R2_filename, file_format = R2_filename.split('.')

    dirpath += '/' + R1_filename + '_' + R2_filename +'_' + 'fastq_join_files/'
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)

    launch_fastq_join(args, dirpath, file_format)

    generate_outputs(dirpath, args)






