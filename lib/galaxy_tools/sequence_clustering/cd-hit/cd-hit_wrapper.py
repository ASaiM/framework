#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

def launch_cd_hit(args, dirpath):

    command = args.src_dir
    command += ' -i ' + args.input_sequence_file
    command += ' -o ' + dirpath + '/clustered'
    command += ' -g ' + args.cluster
    command += ' -c ' + args.seq_id_threshold
    command += ' -G ' + args.seq_id
    command += ' -n ' + args.word_length
    command += ' -l ' + args.throw_away_seq_length
    command += ' -t ' + args.redundance_tolerance
    command += ' -s ' + args.length_diff_cutoff
    command += ' -S ' + args.aa_length_diff_cutoff
    command += ' -aL ' + args.longer_seq_alignment_coverage
    command += ' -AL ' + args.longer_seq_alignment_coverage_control
    command += ' -aS ' + args.shorter_seq_alignment_coverage
    command += ' -AS ' + args.shorter_seq_alignment_coverage_control
    command += ' -A ' + args.minimal_seq_alignment_coverage_control
    command += ' -uL ' + args.longer_seq_max_unmatched_percentage
    command += ' -uS ' + args.shorter_seq_max_unmatched_percentage
    command += ' -U ' + args.max_unmatched_length
    command += ' -b ' + args.band_width
    command += ' -M ' + args.memory_limit
    command += ' -T ' + args.thread_number
    command += ' -d ' + args.description_length
    command += ' -B ' + args.sequence_storage
    command += ' -p ' + args.print_description

    os.system(command)

def test_file_presence(regular_expression, filepaths):
    found_filepath = []
    for filepath in filepaths:
        if re.search(regular_expression, filepath) != None:
            found_filepath.append(filepath)

    if len(found_filepath) == 0 :
        return None
    elif len(found_filepath) > 2 :
        string = "Multiple files found corresponding to the regular expression" 
        string += regular_expression + " in " + str(filepaths)
        raise ValueError(string)
    else:
        return found_filepath[0]

def copy_file(input_filename, input_dir, output_filepath):
    if input_filename != None :
        input_filepath = input_dir + '/' + input_filename
        if not os.path.exists(input_filepath):
            string = "File " + input_filepath + " does not exists"
            raise ValueError(string)
        if output_filepath == None:
            string = "File " + input_filename + " has no output filepath"
            raise ValueError(string)
        os.system('cp ' + input_filepath + ' ' + output_filepath)

def generate_outputs(dirpath, args):
    output_files = os.listdir(dirpath)

    copy_file(test_file_presence('clustered', 
        output_files), dirpath, args.representative_cluster_sequence)
    copy_file(test_file_presence('clustered.clstr', 
        output_files), dirpath, args.cluster_description)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--input_sequence_file', required=True)
    parser.add_argument('--representative_cluster_sequence', required=True)
    parser.add_argument('--cluster_description', required=True)
    parser.add_argument('--cluster', required=True)
    parser.add_argument('--seq_id_threshold', required=True)
    parser.add_argument('--seq_id', required=True)
    parser.add_argument('--word_length', required=True)
    parser.add_argument('--throw_away_seq_length', required=True)
    parser.add_argument('--redundance_tolerance', required=True)
    parser.add_argument('--length_diff_cutoff', required=True)
    parser.add_argument('--aa_length_diff_cutoff', required=True)
    parser.add_argument('--longer_seq_alignment_coverage', required=True)
    parser.add_argument('--longer_seq_alignment_coverage_control', required=True)
    parser.add_argument('--shorter_seq_alignment_coverage', required=True)
    parser.add_argument('--shorter_seq_alignment_coverage_control', required=True)
    parser.add_argument('--minimal_seq_alignment_coverage_control', required=True)
    parser.add_argument('--longer_seq_max_unmatched_percentage', required=True)
    parser.add_argument('--shorter_seq_max_unmatched_percentage', required=True)
    parser.add_argument('--max_unmatched_length', required=True)
    parser.add_argument('--band_width', required=True)
    parser.add_argument('--memory_limit', required=True)
    parser.add_argument('--thread_number', required=True)
    parser.add_argument('--description_length', required=True)
    parser.add_argument('--sequence_storage', required=True)
    parser.add_argument('--print_description', required=True)
    parser.add_argument('--delete_tmp_dirpath', required=True)
    args = parser.parse_args()

    dirpath, filename = os.path.split(os.path.abspath(args.input_sequence_file))
    filename, file_format = filename.split('.')
    dirpath += '/' + filename +'_framebot_file/'
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)

    launch_cd_hit(args, dirpath)
    generate_outputs(dirpath, args)

    if args.delete_tmp_dirpath:
        os.system('rm -rf ' + dirpath)