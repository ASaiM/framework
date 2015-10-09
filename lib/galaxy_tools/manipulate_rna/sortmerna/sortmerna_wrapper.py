#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

def generate_ref_argument(dbs, dirpath):
    indexed_db_dirpath = dirpath + '/indexed_db_dirpath/'
    if not os.path.exists(indexed_db_dirpath):
        os.makedirs(indexed_db_dirpath)

    ref = ''
    sep = ''
    for db in dbs:
        ref += sep + db + ',' 
        ref += indexed_db_dirpath + os.path.split(os.path.abspath(db))[1]
        sep = ':'

    return ref

def launch_indexdb_rna(args, ref_string):
    command = args.src_dir + '/tools/manipulate_rna/sortmerna/sortmerna/indexdb_rna'
    command += ' --ref ' + ref_string
    command += ' -L ' + args.seed_length
    command += ' --max_pos ' + args.max_pos
    os.system(command)

def launch_sortmerna(args, ref_string, dirpath):
    command = args.src_dir + '/tools/manipulate_rna/sortmerna/sortmerna/sortmerna'
    command += ' --ref ' + ref_string
    command += ' --reads ' + args.input_sequence_file
    command += ' --aligned ' + dirpath + '/aligned_sequences'
    
    if args.aligned_sequence_file != None:
        command += ' --fastx'

    if args.rejected_sequence_file != None:
        command += ' --other ' + dirpath + '/rejected_sequences'

    if args.sam_alignment_file != None:
        command += ' --sam'
    
    if args.add_sq_tag == 'yes':
        command += ' --SQ'

    if args.blast_output_file != None:
        if args.blast_output_format == "0":
            command += ' --blast 0'
        elif args.blast_output_format == "1" :
            command += " --blast '1'"
        elif args.blast_output_format == "2" :
            command += " --blast '1 cigar'"
        elif args.blast_output_format == "3" :
            command += " --blast '1 cigar qcov'"
        elif args.blast_output_format == "4" :
            command += " --blast '1 cigar qcov qstrand'"    

    if args.log_file != None:
        command += ' --log'

    if args.best != None:
        command += ' --best ' + args.best
    if args.min_lis != None:
        command += ' --min_lis ' + args.min_lis
    if args.num_alignments != None:
        command += ' --num_alignments' + args.num_alignments

    command += ' --match ' + args.match
    command += ' --mismatch ' + args.mismatch
    command += ' --gap_open ' + args.gap_open
    command += ' --gap_ext ' + args.gap_ext
    command += ' -N ' + args.ambiguous_letter

    if args.strand == 'forward':
        command += ' -F '
    elif args.strand == 'reverse':
        command += ' -R '

    command += ' -e ' + args.e_value

    print command
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

    copy_file(test_file_presence('aligned_sequences.dat', 
        output_files), dirpath, args.aligned_sequence_file)
    copy_file(test_file_presence('rejected_sequences.dat', 
        output_files), dirpath, args.rejected_sequence_file)
    copy_file(test_file_presence('aligned_sequences.sam', 
        output_files), dirpath, args.sam_alignment_file)
    copy_file(test_file_presence('aligned_sequences.blast', 
        output_files), dirpath, args.blast_output_file)
    copy_file(test_file_presence('aligned_sequences.log', 
        output_files), dirpath, args.log_file)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--input_sequence_file', required=True)
    parser.add_argument('--db', required=True, action='append')
    parser.add_argument('--aligned_sequence_file')
    parser.add_argument('--rejected_sequence_file')
    parser.add_argument('--sam_alignment_file')
    parser.add_argument('--add_sq_tag')
    parser.add_argument('--blast_output_file')
    parser.add_argument('--blast_output_format')
    parser.add_argument('--log_file')
    parser.add_argument('--best')
    parser.add_argument('--min_lis')
    parser.add_argument('--num_alignments')
    parser.add_argument('--e_value', required=True)
    parser.add_argument('--match', required=True)
    parser.add_argument('--mismatch', required=True)
    parser.add_argument('--gap_open', required=True)
    parser.add_argument('--gap_ext', required=True)
    parser.add_argument('--ambiguous_letter', required=True)
    parser.add_argument('--strand', required=True)
    parser.add_argument('--seed_length', required=True)
    parser.add_argument('--max_pos', required=True)
    parser.add_argument('--delete_tmp_dirpath', required=True)
    args = parser.parse_args()

    print args

    dirpath, filename = os.path.split(os.path.abspath(args.input_sequence_file))
    filename, file_format = filename.split('.')
    dirpath += '/' + filename +'_sortmerna_files/'
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)

    ref = generate_ref_argument(args.db, dirpath)
    print ref

    launch_indexdb_rna(args, ref)
    launch_sortmerna(args, ref, dirpath)

    generate_outputs(dirpath, args)

    if args.delete_tmp_dirpath:
        os.system('rm -rf ' + dirpath)





