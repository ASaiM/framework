#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

reago_dir = '/tools/rna_manipulation/reago/reago/'

def launch_filter_input(args, ref_string, dirpath):
    command = 'python ' + reago_dir + 'filter_input.py '
    command += args.r1_input_sequence_file + ' ' + args.r2_input_sequence_file
    command += dirpath
    command += reago_dir + '/cm ab 4'
    os.system(command)

def launch_sortmerna(args, ref_string, dirpath):
    command = 'python ' + reago_dir + 'reago.py '
    command += dirpath + '.fasta'
    command += dirpath
    command += ' -l' + args.read_length
    command += ' -o' + args.overlap
    command += ' -e' + args.error_correction
    command += ' -t' + args.tip_size 
    command += ' -b' + args.path_finding_parameter
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

    copy_file(test_file_presence('full_genes.fasta', 
        output_files), dirpath, args.aligned_sequence_file)
    copy_file(test_file_presence('fragments.fasta', 
        output_files), dirpath, args.rejected_sequence_file)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--r1_input_sequence_file', required=True)
    parser.add_argument('--r2_input_sequence_file', required=True)
    parser.add_argument('--full_gene_sequence_file', required=True)
    parser.add_argument('--fragment_sequence_file', required=True)
    parser.add_argument('--read_length', required=True)
    parser.add_argument('--overlap', required=True)
    parser.add_argument('--error_correction', required=True)
    parser.add_argument('--tip_size', required=True)
    parser.add_argument('--path_finding_parameter', required=True)
    args = parser.parse_args()

    print args

    dirpath, filename = os.path.split(os.path.abspath(args.output_sequence_file))
    filename, file_format = filename.split('.')
    dirpath += '/' + filename +'_reago_files/'
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)

    launch_filter_input(args, dirpath)
    launch_reago(args, dirpath)
    generate_outputs(dirpath, args)






