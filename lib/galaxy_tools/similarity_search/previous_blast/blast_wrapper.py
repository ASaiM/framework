#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

def launch_blast(args, blast_src):
    command = blast_src 
    command += ' -query ' + args.input_sequence_file
    command += ' -db ' + args.db
    command += ' -out ' + args.similarity_search_report_file
    if args.blast_executable == 'blastn':
        command += ' -strand ' + args.strand
    elif args.blast_executable == "blastp":

    elif args.blast_executable == "blastx":
        command += ' -strand ' + args.strand
    elif args.blast_executable == "tblastn":
    elif args.blast_executable == "tblastx":
        command += ' -strand ' + args.strand
    else:
        string = "Unknown executable ", args.blast_executable
    command += ' -evalue ' + args.e_value
    os.system(command)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--input_sequence_file', required=True)
    parser.add_argument('--db', required=True, action='append')
    parser.add_argument('--os', required=True)
    parser.add_argument('--blast_executable', required=True)
    parser.add_argument('--similarity_search_report_file', required=True)
    parser.add_argument('--strand')
    parser.add_argument('--query_gencode')
    parser.add_argument('--task')
    parser.add_argument('--e_value', required=True)
    parser.add_argument('--db_gencode')
    
    args = parser.parse_args()

    blast_src = args.src_dir + '/tools/similarity_search/blast'
    if args.os == 'linux':
        blast_src += 'ncbi-blast-2.2.31+-x64-linux/'
    elif args.os == 'mac':
        blast_src += 'ncbi-blast-2.2.31+-universal-macosx/'
    else:
        string = 'Unknown os', args.os
        raise ValueError(string)
    blast_src += '/bin/' + args.blast_executable

    launch_blast(args, blast_src)
