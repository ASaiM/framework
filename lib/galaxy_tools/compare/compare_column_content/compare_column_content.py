#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
from sets import Set

def search(info, info_list):
    return info in info_list

def compare_files(args):
    with open(args.report,'w') as report:
        file1_content = Set([])
        line_nb = 0
        with open(args.file_1,'r') as file_1:
            for line in file_1.readlines():
                split_line = line.split(args.file_1_column_separator)
                file1_content.add(split_line[args.file_1_column_to_compare])
                line_nb += 1
        report.write('Line  in ' + args.file_1 + ': '+ str(line_nb) + '\n')

        similar_content = Set([])
        spec_file_2 = 0
        similar_file_2 = 0
        line_nb = 0
        with open(args.file_2,'r') as file_2:
            with open(args.file_2_spec_info_file,'w') as file_2_spec_info_file:
                with open(args.file_2_similar_info_file,'w') as file_2_similar_info_file:
                    for line in file_2.readlines():
                        split_line = line[:-1].split(args.file_2_column_separator)
                        info = split_line[args.file_2_column_to_compare]
                        found_in_similar = search(info, similar_content)
                        found_in_file1 = search(info, file1_content)
                        if not found_in_similar:
                            if found_in_file1:
                                similar_content.add(info)
                                file_2_similar_info_file.write(line)
                                file1_content.remove(info)
                                similar_file_2 += 1
                            else:
                                file_2_spec_info_file.write(line)
                                spec_file_2 += 1
                        else:
                            if found_in_file1:
                                string = 'In ' + args.file_2
                                string += info + ' found in similar and specific '
                                string += 'content'
                                raise ValueError(string)
                            else:
                                file_2_similar_info_file.write(line)
                                similar_file_2 += 1
                        line_nb += 1
        report.write('Line in ' + args.file_2 + ': ' + str(line_nb) + '\n')

        spec_file_1 = 0
        similar_file_1 = 0
        with open(args.file_1,'r') as file_1:
            with open(args.file_1_spec_info_file,'w') as file_1_spec_info_file:
                with open(args.file_1_similar_info_file,'w') as file_1_similar_info_file:
                    for line in file_1.readlines():
                        split_line = line.split(args.file_1_column_separator)
                        info = split_line[args.file_1_column_to_compare]
                        found_in_similar = search(info, similar_content)
                        found_file1_content = search(info, file1_content)
                        if not found_in_similar :
                            if found_file1_content:
                                file_1_spec_info_file.write(line)
                                spec_file_1 += 1
                            else:
                                string = info + ' found neither in similar or '
                                string += 'specific content'
                                raise ValueError(string)
                        else:
                            if found_file1_content:
                                string = 'In ' + args.file_1
                                string = info + ' found in similar and specific '
                                string += 'content'
                                raise ValueError(string)
                            else:
                                file_1_similar_info_file.write(line)
                                similar_file_1 += 1

        report.write('Similar lines in ' + args.file_1 + ': ')
        report.write(str(similar_file_1) + '\n')
        report.write('Specific lines in ' + args.file_1 + ': ')
        report.write(str(similar_file_1) + '\n')
        report.write('Similar lines in ' + args.file_2 + ': ')
        report.write(str(similar_file_2) + '\n')
        report.write('Specific lines in ' + args.file_2 + ': ')
        report.write(str(similar_file_2) + '\n')

########
# Main #
########
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--file_1', required=True)
    parser.add_argument('--file_1_column_number', required=True)
    parser.add_argument('--file_1_column_to_compare', required=True)
    parser.add_argument('--file_1_column_separator', required=True)   
    parser.add_argument('--file_1_spec_info_file', required=True) 
    parser.add_argument('--file_1_similar_info_file', required=True)   
    parser.add_argument('--file_2', required=True)
    parser.add_argument('--file_2_column_number', required=True)
    parser.add_argument('--file_2_column_to_compare', required=True)
    parser.add_argument('--file_2_column_separator', required=True)
    parser.add_argument('--file_2_spec_info_file', required=True) 
    parser.add_argument('--file_2_similar_info_file', required=True)  
    parser.add_argument('--report', required=True)
    args = parser.parse_args()

    if int(args.file_1_column_to_compare) > int(args.file_1_column_number):
        string = 'In file '+ args.file_1
        string = ' Column number ('+ args.file_1_column_number + ') is inferior '
        string += 'to column to compare (' + args.file_1_column_to_compare + ')'
        raise ValueError(string)
    if int(args.file_2_column_to_compare) > int(args.file_2_column_number):
        string = 'In file ' + args.file_2
        string = ' Column number (' + args.file_2_column_number + ') is inferior '
        string += 'to column to compare (' + args.file_2_column_to_compare + ')'
        raise ValueError(string)

    compare_files(args)