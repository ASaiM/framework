#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import copy
import operator

#################
# Parse methods #
#################
def blast_0_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 0 not implemented' 
    raise ValueError(string)

def blast_1_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 1 not implemented' 
    raise ValueError(string)

def blast_2_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 2 not implemented' 
    raise ValueError(string)

def blast_3_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 3 not implemented' 
    raise ValueError(string)

def blast_4_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 4 not implemented' 
    raise ValueError(string)

def blast_5_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 5 not implemented' 
    raise ValueError(string)

def blast_6_parse_method(input_file, use_default_specifiers = 'default'):
    records = []
    format_specifiers = format_spec['blast']['6']['specifiers'][use_default_specifiers]
    exp_specifier_nb = len(format_specifiers)
    for row in input_file.readlines():
        similarity_info = SimilarityInformation('blast')
        split_row = row[:-1].split('\t')

        if len(split_row) != exp_specifier_nb:
            string = os.path.basename(__file__) + ': '
            string += row + ' has not the correct number of columns '
            string += 'for blast -outfmt 10 and '
            string += use_default_specifiers
            raise ValueError(string)

        for i in range(exp_specifier_nb):
            similarity_info.set(format_specifiers[i],split_row[i],'blast')
        records.append(similarity_info)
    return records

def blast_7_parse_method(input_file, use_default_specifiers = 'default'):
    records = []
    format_specifiers = format_spec['blast']['7']['specifiers'][use_default_specifiers]
    exp_specifier_nb = len(format_specifiers)
    for row in input_file.readlines():
        if row[0] == '#':
            continue
        similarity_info = SimilarityInformation('blast')
        split_row = row[:-1].split('\t')

        if len(split_row) != exp_specifier_nb:
            string = os.path.basename(__file__) + ': '
            string += row + ' has not the correct number of columns '
            string += 'for blast -outfmt 10 and '
            string += use_default_specifiers
            raise ValueError(string)

        for i in range(exp_specifier_nb):
            similarity_info.set(format_specifiers[i],split_row[i],'blast')
        records.append(similarity_info)
    return records

def blast_8_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 8 not implemented' 
    raise ValueError(string)

def blast_9_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 9 not implemented' 
    raise ValueError(string)

def blast_10_parse_method(input_file, use_default_specifiers = 'default'):
    records = []
    format_specifiers = format_spec['blast']['10']['specifiers'][use_default_specifiers]
    exp_specifier_nb = len(format_specifiers)
    for row in input_file.readlines():
        if row[0] == '#':
            continue
        similarity_info = SimilarityInformation('blast')
        split_row = row[:-1].split(',')

        if len(split_row) != exp_specifier_nb:
            string = os.path.basename(__file__) + ': '
            string += row + ' has not the correct number of columns '
            string += 'for blast -outfmt 10 and '
            string += use_default_specifiers
            raise ValueError(string)

        for i in range(exp_specifier_nb):
            similarity_info.set(format_specifiers[i],split_row[i], 'blast')
        records.append(similarity_info)
    return records

def blast_11_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 11 not implemented' 
    raise ValueError(string)

def blast_12_parse_method(input_file, use_default_specifiers = 'default'):
    string = os.path.basename(__file__) + ': ' 
    string += 'Parsing method for blast 12 not implemented' 
    raise ValueError(string)

#########################
# Format specifications #
#########################
format_spec = {}
format_spec['blast'] = {}

format_spec['blast']['all_specifiers'] = {
    'qseqid': str,
    'sseqid': str,
    'pident': float,
    'length': int,
    'mismatch': int,
    'gapopen': int,
    'qstart': int,
    'qend': int,
    'sstart': int,
    'send': int,
    'evalue': float,
    'bitscore': float,
    'cigar': str,
    'coverage': float
}
format_spec['blast']['0'] = {
    'parse_method': blast_0_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['1'] = {
    'parse_method': blast_1_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['2'] = {
    'parse_method': blast_2_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['3'] = {
    'parse_method': blast_3_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['4'] = {
    'parse_method': blast_4_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['5'] = {
    'parse_method': blast_5_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['6'] = {
    'parse_method': blast_6_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['6']['specifiers']['cigar'] = copy.copy(
    format_spec['blast']['6']['specifiers']['default'])
format_spec['blast']['6']['specifiers']['cigar'].append('cigar')
format_spec['blast']['6']['specifiers']['cigar_coverage'] = copy.copy(
    format_spec['blast']['6']['specifiers']['cigar'])
format_spec['blast']['6']['specifiers']['cigar_coverage'].append('coverage')
format_spec['blast']['7'] = {
    'parse_method': blast_7_parse_method,
    'specifiers':copy.copy(format_spec['blast']['6']['specifiers'])
}
format_spec['blast']['8'] = {
    'parse_method': blast_8_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['9'] = {
    'parse_method': blast_9_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['10'] = {
    'parse_method': blast_10_parse_method,
    'specifiers':copy.copy(format_spec['blast']['6']['specifiers'])
}
format_spec['blast']['11'] = {
    'parse_method': blast_11_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}
format_spec['blast']['12'] = {
    'parse_method': blast_12_parse_method,
    'specifiers':{
        'default': ['qseqid','sseqid','pident','length','mismatch','gapopen',
            'qstart','qend','sstart','send','evalue','bitscore']
    }
}

#########################
# Constraint definition #
#########################
constraints = {
    'equal': operator.eq,
    'different': operator.ne,
    'lower': operator.le,
    'strictly_lower': operator.lt,
    'greater': operator.ge,
    'strictly_greater': operator.gt,
    'in': operator.contains,
    'not_in': 'in'
}


###########
# Classes #
###########
class SimilarityInformation:

    def __init__(self, tool):
        self.information = {}
        for info in format_spec[tool]['all_specifiers']:
            self.information[info] = -1

    def get(self,category):
        return self.information[category]

    def set(self,category,new_value, tool):
        format_method = format_spec[tool]['all_specifiers'][category]
        self.information[category] = format_method(new_value)

    def extract_information(self,to_extract):
        extracted_info = []
        for info_to_extract in to_extract:
            extracted_info.append(self.get(info_to_extract))
        return extracted_info

    def test_conservation(self, constraints):
        to_conserve = True
        for constrained_info in constraints:
            record_value = self.get(constrained_info)
            for constraint in constraints[constrained_info]:
                to_conserve &= constraint.test_constraint(record_value)
        return to_conserve

class Records:

    def __init__(self, input_filepath, tool, format, constraints,
        use_default_specifiers = 'default'):
        self.records = []
        with open(input_filepath, 'r') as input_file:
            parse_function = format_spec[tool][format]['parse_method']
            self.records = parse_function(input_file, use_default_specifiers)

        self.conserved_records = []
        for record in self.records:
            to_conserve = record.test_conservation(constraints)
            if to_conserve:
                self.conserved_records.append(copy.copy(record))

    # Getters
    def get_records(self):
        return copy.copy(self.records)

    def get_record_nb(self):
        return len(self.records)

    def get_conserved_records(self):
        return copy.copy(self.conserved_records)

    def get_conserved_record_nb(self):
        return len(self.conserved_records)

    # Other functions
    def save_conserved_records(self,output_filepath, to_extract):
        with open(output_filepath, 'w') as output_file:
            output_file.write('\t'.join(to_extract) + '\n')
            for record in self.conserved_records:
                extracted_info = record.extract_information(to_extract)
                string_info = [str(info) for info in extracted_info]
                string = '\t'.join(string_info)
                output_file.write(string + '\n')

class Constraint:

    def __init__(self, constraint_type, value, constrained_information, tool):
        if not constraints.has_key(constraint_type):
            string = os.path.basename(__file__) + ': '
            string += constraint_type + ' is not a correct type of constraint'
            raise ValueError(string)
        self.raw_constraint_type = constraint_type
        self.type = constraints[constraint_type]

        value_format = format_spec[tool]['all_specifiers'][constrained_information]
        if self.raw_constraint_type in ['in', 'not_in']:
            self.values = []
            with open(value, 'r') as value_file:
                for row in value_file.readlines():
                    value = row[:-1]
                    self.values.append(value_format(value))
        else:
            self.values = [value_format(value)]

    def get_raw_constraint_type(self):
        return self.raw_constraint_type

    def get_type(self):
        return self.type

    def get_values(self):
        return self.values

    def test_constraint(self, similarity_info_value):
        to_conserve = True
        if self.raw_constraint_type == 'in':
            to_conserve &= (similarity_info_value in self.values)
        elif self.raw_constraint_type == 'not_in':
            to_conserve &= (similarity_info_value not in self.values)
        else:
            to_conserve &= self.type(similarity_info_value, self.values[0])
        return to_conserve    

################
# Misc methods #
################
def test_format(filepath, tool, file_format):

    if not format_spec.has_key(tool):
    	string = os.path.basename(__file__) + ': ' 
    	string += tool 
    	string += ' is not a correct tool to generate sequence similarity report'
        raise ValueError(string)

    if not format_spec[tool].has_key(file_format):
        string = os.path.basename(__file__) + ': ' 
        string += file_format 
        string += ' is not a correct format for tool' + tool
        raise ValueError(string)

    return True

def test_input_filepath(input_filepath, tool, file_format):
    if not os.path.exists(input_filepath):
        string = os.path.basename(__file__) + ': '
        string += input_filepath + ' does not exist'
        raise ValueError(string)
    test_format(input_filepath, tool, file_format)

def format_constraints(constraints, tool):
    formatted_constraints = {}
    if constraints != None:
        for constr in constraints:
            split_constraint = constr.split(': ')
            constrained_information = split_constraint[0]
            constraint = Constraint(split_constraint[1], split_constraint[2], 
                constrained_information, tool)
            formatted_constraints.setdefault(constrained_information,[]).append(
                constraint)
    return formatted_constraints

def extract_similarity_search_report(args):
    input_filepath = args.input
    tool = args.tool
    file_format = str(args.format)
    use_default_specifiers = args.use_default_specifiers
    to_extract = args.to_extract
    to_extract = to_extract[1:-1].split(',')
    constraints = args.constraint
    report_filepath = args.report
    output_filepath = args.output

    test_input_filepath(input_filepath, tool, file_format)

    formatted_constraints = format_constraints(constraints, tool)

    records = Records(input_filepath, tool, file_format, formatted_constraints, 
        use_default_specifiers)
    records.save_conserved_records(output_filepath, to_extract)
    
    with open(report_filepath, 'w') as report_file:
        report_file.write('Information to extract:\n')
        for info in to_extract:
            report_file.write('\t' + info + '\n')
        if constraints != None:
            report_file.write('Constraints on extraction:\n')
            for constrained_info in formatted_constraints:
                report_file.write('\tInfo to constraint: ' + constrained_info 
                    + '\n')
                for constraint in formatted_constraints[constrained_info]:
                    report_file.write('\t\tType of constraint: ' + 
                        constraint.get_raw_constraint_type()
                        + '\n')
                    report_file.write('\t\tValues:\n')
                    values = constraint.get_values()
                    for value in values:
                        report_file.write('\t\t\t' + str(value) + '\n')
        report_file.write('Number of similarity records: ' + 
            str(records.get_record_nb()) + '\n')
        report_file.write('Number of extracted similarity records: ' +
            str(records.get_conserved_record_nb()) + '\n')

########
# Main #
########
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--tool', required=True)
    parser.add_argument('--format', required=True)
    parser.add_argument('--use_default_specifiers')
    parser.add_argument('--to_extract', required=True)
    parser.add_argument('--constraint', action='append')
    parser.add_argument('--report', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()

    extract_similarity_search_report(args)
