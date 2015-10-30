#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import copy
import operator
from sets import Set

def extract_mapping_info(input_mapping_filepath):
    mapping_info = {}
    categories = Set([])

    with open(input_mapping_filepath,'r') as mapping_file:
        for line in mapping_file.readlines():
            split_line = line[:-1].split('\t')
            mapping_info.setdefault(split_line[0],split_line[1])
            categories.add(split_line[1])

    return mapping_info, categories

def init_category_distribution(categories = None):
    cluster_category_distribution = {}
    if categories != None:
        for category in categories:
            cluster_category_distribution[category] = 0
    return cluster_category_distribution

def flush_cluster_info(cluster_name, cluster_ref_seq, ref_seq_cluster, 
    cluster_category_distribution, categories, output_category_distribution_file):
    if cluster_name != '':
        if categories != None:
            output_category_distribution_file.write(cluster_name)
            for category in categories:
                output_category_distribution_file.write('\t')
                output_category_distribution_file.write(str(cluster_category_distribution[category]))
            output_category_distribution_file.write('\n')

        if cluster_ref_seq == '':
            string = "No reference sequence found for "
            string += cluster_name
            raise ValueError(string)

        ref_seq_cluster.setdefault(cluster_ref_seq, cluster_name)

def extract_cluster_info(args, mapping_info = None, categories = None):
    ref_seq_cluster = {}

    if args.output_category_distribution != None:
        if mapping_info == None or categories == None:
            string = "A file with category distribution is expected but "
            string += "no mapping information are available"
            raise ValueError(string)
        output_category_distribution_file = open(
            args.output_category_distribution, 'w')
        output_category_distribution_file.write('Cluster')
        for category in categories:
            output_category_distribution_file.write('\t' + category)
        output_category_distribution_file.write('\n')

    with open(args.input_cluster_info,'r') as cluster_info_file:
        cluster_name = ''
        cluster_category_distribution = init_category_distribution(categories)
        cluster_abundance_number = 0
        cluster_ref_seq = ''
        for line in cluster_info_file.readlines():
            if line[0] == '>':
                flush_cluster_info(cluster_name, cluster_ref_seq, ref_seq_cluster, 
                    cluster_category_distribution, categories, 
                    output_category_distribution_file)
                cluster_name = line[1:-1]
                if cluster_name.replace(' ','_') 
                cluster_category_distribution = init_category_distribution(categories)
                cluster_ref_seq = ''
            else:
                seq_info = line[:-1].split('\t')[1].split(' ')
                seq_name = seq_info[1][1:-3]

                if categories != None:
                    seq_count = 1
                    if args.number_sum == 'False':
                        if seq_name.find('size') != -1:
                            substring = seq_name[seq_name.find('size'):-1]
                            seq_count = int(substring.split('=')[1])
                    if not mapping_info.has_key(seq_name):
                        string = seq_name + " not found in mapping"
                        raise ValueError(string)
                    category = mapping_info[seq_name]
                    cluster_category_distribution[category] += seq_count

                
                if seq_info[-1] == '*':
                    print seq_info
                    if cluster_ref_seq != '':
                        string = "A reference sequence (" + cluster_ref_seq
                        string += ") already found for cluster " + cluster_name 
                        string += " (" + seq_name + ")"
                        raise ValueError(string)
                    cluster_ref_seq = seq_name
                    print '\tRef seq', cluster_name

        flush_cluster_info(cluster_name, cluster_ref_seq, ref_seq_cluster, 
            cluster_category_distribution, categories, 
            output_category_distribution_file)

    if args.output_category_distribution != None:
        output_category_distribution_file.close()

    return ref_seq_cluster

def rename_representative_sequences(args, ref_seq_cluster):
    with open(args.input_representative_sequences,'r') as input_sequences:
        with open(args.output_representative_sequences,'w') as output_sequences:
            for line in input_sequences.readlines():
                if line[0] == '>':
                    seq_name = line[1:-1]
                    if not ref_seq_cluster.has_key(seq_name):
                        string = seq_name + " not found as reference sequence"
                        raise ValueError(string)
                    output_sequences.write('>' + ref_seq_cluster[seq_name] + '\n')
                else:
                    output_sequences.write(line)

def format_cd_hit_outputs(args):
    if args.input_mapping != None:
        mapping_info, categories = extract_mapping_info(args.input_mapping)
    else:
        mapping_info = None
        categories = None

    ref_seq_cluster = extract_cluster_info(args, mapping_info, categories)

    if args.input_representative_sequences != None:
        rename_representative_sequences(args, ref_seq_cluster)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_cluster_info', required=True)
    parser.add_argument('--input_representative_sequences')
    parser.add_argument('--output_representative_sequences')
    parser.add_argument('--input_mapping')
    parser.add_argument('--output_category_distribution')
    parser.add_argument('--number_sum')
    args = parser.parse_args()
    print args

    format_cd_hit_outputs(args)