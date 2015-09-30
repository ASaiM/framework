#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import re

def launch_uchime_denovo(args):
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

    command += ' -uchime_denovo'
    command += ' ' + args.input_sequence_file

    if args.uchimeout_file != None :
        command += ' -uchimeout ' + args.uchimeout_file
    
    if args.uchimealns_file != None:
        command += ' -uchimealns ' + args.uchimealns_file

    if args.chimeras_file != None:
        command += ' -chimeras ' + args.chimeras_file

    if args.nonchimeras_file != None:
        command += ' -nonchimeras ' + args.nonchimeras_file

    if args.chimerasq_file != None:
        command += ' -chimerasq ' + args.chimerasq_file

    if args.nonchimerasq_file != None:
        command += ' -nonchimerasq ' + args.nonchimerasq_file

    command += ' -minh ' + args.minimum_score
    command += ' -xn ' + args.no_vote_weight
    command += ' -dn ' + args.no_vote_pseudo_count
    command += ' -mindiffs ' + args.min_diff_nb
    command += ' -mindiv ' + args.min_div
    command += ' -abskew ' + args.abundance_skew

    os.system(command)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--src_dir', required=True)
    parser.add_argument('--input_sequence_file', required=True)
    parser.add_argument('--uchimeout_file')
    parser.add_argument('--uchimealns_file')
    parser.add_argument('--chimeras_file_format')
    parser.add_argument('--chimeras_file')
    parser.add_argument('--nonchimeras_file')
    parser.add_argument('--chimerasq_file')
    parser.add_argument('--nonchimerasq_file')
    parser.add_argument('--minimum_score', required=True)
    parser.add_argument('--no_vote_weight', required=True)
    parser.add_argument('--no_vote_pseudo_count', required=True)
    parser.add_argument('--min_diff_nb', required=True)
    parser.add_argument('--min_div', required=True)
    parser.add_argument('--abundance_skew', required=True)
    parser.add_argument('--os', required=True)
    args = parser.parse_args()
    print args

    launch_uchime_denovo(args)