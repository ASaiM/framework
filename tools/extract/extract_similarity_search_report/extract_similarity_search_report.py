#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import copy
import operator

# Information category definition
information_categories = {}
information_categories['query'] = str
information_categories['target'] = str
information_categories['identity_percentage'] = float
information_categories['alignment_length'] = int
information_categories['mismatch_number'] = int
information_categories['open_gap_number'] = int
information_categories['query_start_pos'] = int
information_categories['query_end_pos'] = int
information_categories['target_start_pos'] = int
information_categories['target_end_pos'] = int
information_categories['e_value'] = float
information_categories['bit_score'] = float
information_categories['cigar_string'] = str
information_categories['coverage'] = float

# Format definition
sequence_similarity_report_format = {}
sequence_similarity_report_format['BLAST_6'] = ['query', 
        'target',
        'identity_percentage',
        'alignment_length',
        'mismatch_number',
        'open_gap_number',
        'query_start_pos',
        'query_end_pos',
        'target_start_pos',
        'target_end_pos',
        'e_value',
        'bit_score']
sequence_similarity_report_format['BLAST_6_CIGAR'] = copy.copy(
	sequence_similarity_report_format['BLAST_6'])
sequence_similarity_report_format['BLAST_6_CIGAR'].append('cigar_string')
sequence_similarity_report_format['BLAST_6_CIGAR_Coverage'] = copy.copy(
	sequence_similarity_report_format['BLAST_6_CIGAR'])
sequence_similarity_report_format['BLAST_6_CIGAR_Coverage'].append('coverage')

# Constraint definition
constraints = {}
constraints['equal'] = operator.eq
constraints['different'] = operator.ne
constraints['lower'] = operator.le
constraints['strictly_lower'] = operator.lt
constraints['greater'] = operator.ge
constraints['strictly_greater'] = operator.gt
constraints['in'] = operator.contains
constraints['not_in'] = 'in'

class SimilarityInformation:

    def __init__(self):
        self.information = {}
        for info in information_categories:
            self.information[info] = -1

    def get(self,category):
        return self.information[category]

    def set(self,category,new_value):
        if category not in information_categories:
            string = os.path.basename(__file__) + ': '
            string += category + ' is not a correct category for '
            string += 'sequence similarity information'
            raise ValueError(string)
        self.information[category] = new_value

class Constraint:

    def __init__(self, constraint_type, value, constrained_information):
        if not constraints.has_key(constraint_type):
            string = os.path.basename(__file__) + ': '
            string += constraint_type + ' is not a correct type of constraint'
            raise ValueError(string)
        self.raw_constraint_type = constraint_type
        self.type = constraints[constraint_type]

        value_format = information_categories[constrained_information]
        if self.raw_constraint_type in ['in', 'not_in']:
            self.values = []
            with open(value, 'r') as value_file:
                for row in value_file.readlines():
                    value = row[:-1]
                    self.values.append(value_format(value))
        else:
            self.value = value_format(value)

    def get_type(self):
        return self.type

    def get_value(self):
        return self.value

    def test_constraint(self, similarity_info_value):
        to_conserve = True
        if self.raw_constraint_type == 'in':
            to_conserve &= (similarity_info_value in self.values)
        elif self.raw_constraint_type == 'not_in':
            to_conserve &= (similarity_info_value not in self.values)
        else:
            to_conserve &= self.type(similarity_info_value, self.value)
        return to_conserve    

def transform_row(row, file_format):
    transformed_row = []
    if file_format in ['BLAST_6','BLAST_6_CIGAR','BLAST_6_CIGAR_Coverage'] :
        transformed_row = row[:-1].split('\t')
    return transformed_row

def format_into_string(info, file_format):
    row = ''
    string_info = [str(inf) for inf in info]
    if file_format in ['BLAST_6','BLAST_6_CIGAR','BLAST_6_CIGAR_Coverage'] :
        row = '\t'.join(string_info)
    return row

def test_format(filepath, file_format):
    if not sequence_similarity_report_format.has_key(file_format):
    	string = os.path.basename(__file__) + ': ' 
    	string += file_format 
    	string += ' is not a correct format for sequence similarity report'
        raise ValueError(string)

    with open(filepath, 'r') as report_file:
        for row in report_file.readlines():
            transformed_row = transform_row(row, file_format)
            expected_info_nb = len(sequence_similarity_report_format[file_format])
            observed_info_nb = len(transformed_row)
            if observed_info_nb != expected_info_nb:
            	string = os.path.basename(__file__) + ': ' 
            	string += file_format + ' format is not respected '
            	string += '(wrong column number with ' + str(observed_info_nb)
            	string += 'columns for ' + row + ')'
                raise ValueError(string) 
    return True

def test_extraction(to_extract, file_format):
	for info in to_extract:
		if info not in sequence_similarity_report_format[file_format]:
			string = os.path.basename(__file__) + ': ' 
			string += info + ' is not a correct information to extract from ' 
			string += file_format + ' file'
			raise ValueError(string)

def format_constraints(constraints):
    formatted_constraints = {}
    if constraints != None:
        for constr in constraints:
            split_constraint = constr.split(': ')
            constrained_information = split_constraint[0]
            constraint = Constraint(split_constraint[1], split_constraint[2], 
                constrained_information)
            formatted_constraints.setdefault(constrained_information,[]).append(
                constraint)
    return formatted_constraints

def extract_similarity_information(row, file_format):
    similarity_info = SimilarityInformation()
    transformed_row = transform_row(row, file_format)

    for i in range(len(sequence_similarity_report_format[file_format])):
        category = sequence_similarity_report_format[file_format][i]
        value = transformed_row[i]
        formatted_value = information_categories[category](value)
        similarity_info.set(category,formatted_value)
    return similarity_info

def test_conservation_similarity(similarity_info, formatted_constraints):
    to_conserve = True
    for constrained_info in formatted_constraints:
        similarity_info_value = similarity_info.get(constrained_info)
        for constraint in formatted_constraints[constrained_info]:
            to_conserve &= constraint.test_constraint(similarity_info_value)
    return to_conserve

def extract_wanted_information(similarity_info, to_extract):
    extracted_info = []
    for info_to_extract in to_extract:
        extracted_info.append(similarity_info.get(info_to_extract))
    return extracted_info

def extract_similarity_search_report(args):
    input_filepath = args.input
    format = args.format
    to_extract = args.to_extract
    to_extract = to_extract[1:-1].split(',')
    constraints = args.constraint
    report_filepath = args.report
    output_filepath = args.output

    if not os.path.exists(input_filepath):
        string = os.path.basename(__file__) + ': '
        string += input_filepath + ' does not exist'
        raise ValueError(string)
    test_format(input_filepath, format)
    test_extraction(to_extract, format)

    with open(report_filepath, 'w') as report_file:
        report_file.write('Input filepath: ' + input_filepath + '\n')
        report_file.write('Information to extract:')
        for info in to_extract:
            report_file.write(' ' + info)
        report_file.write('\n')
        if constraints != None:
            report_file.write('Constraints on extraction:\n')
            for constraint in constraints:
                report_file.write('\t' + constraint + '\n')

    formatted_constraints = format_constraints(constraints)

    similarity_nb = 0
    extracted_similarity_nb = 0
    with open(input_filepath, 'r') as input_file:
        with open(output_filepath, 'w') as output_file:
            output_file.write('\t'.join(to_extract) + '\n')
            for row in input_file.readlines():
                similarity_nb += 1
                similarity_info = extract_similarity_information(row, format)
                to_conserve = test_conservation_similarity(similarity_info, 
                    formatted_constraints)
                if to_conserve:
                    extracted_similarity_nb += 1
                    extracted_similarity_info = extract_wanted_information( 
                        similarity_info, to_extract)
                    string = format_into_string(extracted_similarity_info, 
                        format)
                    output_file.write(string + '\n')

    with open(report_filepath, 'a') as report_file:
        report_file.write('Similarity number: ' + str(similarity_nb) + '\n')
        report_file.write('Extracted similarity number:')
        report_file.write(str(extracted_similarity_nb) + '\n')


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--format', required=True)
    parser.add_argument('--to_extract', required=True)
    parser.add_argument('--constraint', action='append')
    parser.add_argument('--report', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()

    extract_similarity_search_report(args)
