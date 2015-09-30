#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

def launch_framebot(args, dirpath):
    command = 'java -jar ' 
    command += args.src_dir + 'tools/RDPTools/RDPTools/FrameBot.jar framebot'
    command += ' -a ' + args.alignment_mode
    command += ' -b ' + args.denovo_abund_cutoff
    command += ' -d ' + args.denovo_id_cutoff
   
    command += ' -i ' + args.identity_cutoff
    command += ' -k ' + args.knn
    command += ' -l ' + args.length_cutoff
    
    if args.no_metric_search == 'yes':
        command += ' -N '
        command += ' -e ' + args.gap_ext_penalty
        command += ' -f ' + args.frameshift_penalty
        command += ' -g ' + args.gap_open_penalty
        if args.no_prefilter == 'yes':
            command += ' -P'
        command += ' -x ' + args.scoring_matrix
    else:
        command += ' -m ' + args.max_radius

    command += ' -o ' + dirpath + '/output'
    command += ' -w ' + args.word_size
    
    if args.de_novo == 'yes':
        command += ' -z '
 
    comannd += ' ' + args.input_sequence_file
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

    copy_file(test_file_presence('output_framebot.txt', 
        output_files), dirpath, args.framebot_output_file)
    copy_file(test_file_presence('output_nucl_corr.fasta', 
        output_files), dirpath, args.nucl_corr_output_file)
    copy_file(test_file_presence('all_seqs_derep_prot_corr.fasta', 
        output_files), dirpath, args.all_seqs_derep_prot_corr_output_file)
    copy_file(test_file_presence('output_failed_framebot.txt', 
        output_files), dirpath, args.failed_framebot_output_file)
    copy_file(test_file_presence('output_nucl_failed.fasta', 
        output_files), dirpath, args.nucl_failed_output_file)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--input_sequence_file', required=True)
    parser.add_argument('--alignment_mode', required=True)
    parser.add_argument('--denovo_abund_cutoff', required=True)
    parser.add_argument('--denovo_id_cutoff', required=True)
    parser.add_argument('--gap_ext_penalty')
    parser.add_argument('--frameshift_penalty')
    parser.add_argument('--gap_open_penalty')
    parser.add_argument('--knn', required=True)
    parser.add_argument('--length_cutoff', required=True)
    parser.add_argument('--max_radius')
    parser.add_argument('--no_metric_search', required=True)
    parser.add_argument('--no_prefilter')
    parser.add_argument('--quality_file', required=True)
    parser.add_argument('--transl_table', required=True)
    parser.add_argument('--word_size', required=True)
    parser.add_argument('--scoring_matrix')
    parser.add_argument('--de_novo', required=True)
    parser.add_argument('--framebot_output_file', required=True)
    parser.add_argument('--nucl_corr_output_file', required=True)
    parser.add_argument('--all_seqs_derep_prot_corr_output_file', required=True)
    parser.add_argument('--failed_framebot_output_file', required=True)
    parser.add_argument('--nucl_failed_output_file', required=True)
    args = parser.parse_args()

    dirpath, filename = os.path.split(os.path.abspath(args.input_sequence_file))
    filename, file_format = filename.split('.')
    dirpath += '/' + filename +'_framebot_file/'
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)