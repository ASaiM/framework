#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

reago_dir = '/tools/rna_manipulation/reago/reago/'

def add_read_pair_num(input_filepath, output_filepath, read_pair_num):
    with open(input_filepath,'r') as input_file:
        with open(output_filepath,'w') as output_file:
            for line in input_file:
                if line[0] == '>':
                    split_line = line.split()
                    split_line[0] = split_line[0] + '.' + str(read_pair_num)
                    output_file.write(' '.join(split_line) + '\n')
                else:
                    output_file.write(line)

def launch_filter_input(args, dirpath):
    command = 'python ' + reago_dir + 'filter_input.py '
    command += dirpath + 'reads.1 ' + dirpath + 'reads.2 '
    command += dirpath + ' '
    command += reago_dir + '/cm ab 4'
    os.system(command)

def launch_reago(args, dirpath):
    command = 'python ' + reago_dir + 'reago.py '
    command += dirpath + 'filtered.fasta '
    command += dirpath
    command += ' -l ' + args.read_length
    command += ' -o ' + args.overlap
    command += ' -e ' + args.error_correction
    command += ' -t ' + args.tip_size 
    command += ' -b ' + args.path_finding_parameter
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
        output_files), dirpath, args.full_gene_sequence_file)
    copy_file(test_file_presence('fragments.fasta', 
        output_files), dirpath, args.fragment_sequence_file)

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

    dirpath, r1_filename = os.path.split(os.path.abspath(args.r1_input_sequence_file))
    dirpath, r2_filename = os.path.split(os.path.abspath(args.r2_input_sequence_file))
    r1_filename, file_format = r1_filename.split('.')
    r2_filename, file_format = r2_filename.split('.')
    dirpath += '/' + r1_filename + '_' + r2_filename +'_reago_files/'
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)

    add_read_pair_num(args.r1_input_sequence_file, dirpath + 'reads.1', 1)
    add_read_pair_num(args.r2_input_sequence_file, dirpath + 'reads.2', 2)

    reago_dir = args.src_dir + reago_dir

    launch_filter_input(args, dirpath)
    launch_reago(args, dirpath)
    generate_outputs(dirpath, args)
    #print args





