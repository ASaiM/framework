#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import copy
import operator

FASTA_FILE_LAST_POS = None

#################
# Parse methods #
#################
def text_end_of_file(row):
    if row == '':
        return True
    else:
        return False

def get_new_line(input_file, generate_error = True):
    row = input_file.readline()
    if text_end_of_file(row):
        if generate_error :
            string = os.path.basename(__file__) + ': '
            string += ' unexpected end of file'
            raise ValueError(string)
        else :
            return None
    else:
        return row[:-1]

def next_fasta_record(input_file):
    global FASTA_FILE_LAST_POS
    if FASTA_FILE_LAST_POS != None:
        input_file.seek(FASTA_FILE_LAST_POS)
    else:
        FASTA_FILE_LAST_POS = input_file.tell()

    id_line = get_new_line(input_file, generate_error = False)
    if id_line == None:
        return None
    split_line = id_line[1:].split(' ')
    seq_id = split_line[0]
    description = ' '.join(split_line[1:])
    new_line = get_new_line(input_file, generate_error = False)
    seq = ''
    while new_line != None:
        if new_line[0] != '>':        
            seq += new_line
            FASTA_FILE_LAST_POS = input_file.tell()
            new_line = get_new_line(input_file, generate_error = False)
        else:
            new_line = None
    return SeqRecord(seq_id, seq, description)

def next_fastq_record(input_file):
    id_line = get_new_line(input_file, generate_error = False)
    if id_line == None:
        return None
    if id_line[0] != '@':
        string = os.path.basename(__file__) + ': '
        string += ' issue in fastq file'
        raise ValueError(string)
    split_line = id_line[1:].split(' ')
    seq_id = split_line[0]
    description = ' '.join(split_line[1:])
    seq = get_new_line(input_file)
    spacer = get_new_line(input_file)
    quals = get_new_line(input_file)
    return SeqRecord(seq_id, seq, description, quals)

def next_record(input_file, file_format):
    if file_format == 'fasta':
        return next_fasta_record(input_file)
    elif file_format == 'fastq':
        return next_fastq_record(input_file)
    else:
        string = os.path.basename(__file__) + ': '
        string += file_format + ' is not managed'
        raise ValueError(string)

def write_fasta_record(record, output_sequence_file):
    output_sequence_file.write('>' + record.get_id() + ' ' + 
        record.get_description() + '\n')
    seq = record.get_sequence()
    split_seq = [seq[i:i+60] for i in xrange(0,len(seq),60)]
    for split in split_seq:
        output_sequence_file.write(split + '\n')

def format_qual_value(qual_score, sliding_value, authorized_range, qual_format):
    ascii_value = ord(qual_score)
    score = ascii_value-sliding_value
    if score < authorized_range[0] or score > authorized_range[1]:
        string = os.path.basename(__file__) + ': wrong score ('
        string += str(score) + ') with quality format ('
        string += qual_format
        raise ValueError(string)
    return score

def format_qual_string(qual_string, qual_format):
    if qual_format == 'sanger':
        return format_qual_value(qual_string, 33 ,[0,40], qual_format)
    elif qual_format == "solexa":
        return format_qual_value(qual_string, 64 ,[-5,40], qual_format)
    elif qual_format == "illumina_1_3":
        return format_qual_value(qual_string, 33 ,[0,40], qual_format)
    elif qual_format == "illumina_1_5":
        return format_qual_value(qual_string, 33 ,[3,40], qual_format)
    elif qual_format == "illumina_1_8":
        return format_qual_value(qual_string, 33 ,[0,41], qual_format)
    else:
        string = os.path.basename(__file__) + ': quality format ('
        string += qual_format + ') is not managed'
        raise ValueError(string) 

def write_qual_record(record, output_qual_file, qual_format):
    output_qual_file.write('>' + record.get_id() + ' ' + 
        record.get_description() + '\n')
    qual = record.get_quality()
    qual = [str(format_qual_string(qual_str,qual_format)) for qual_str in qual]
    split_seq = [qual[i:i+60] for i in xrange(0,len(qual),60)]
    for split in split_seq:
        output_qual_file.write(' '.join(split) + '\n')

def write_fastq_record(record, output_sequence_file):
    output_sequence_file.write('@' + record.get_id() + ' ' + 
        record.get_description() + '\n')
    output_sequence_file.write(record.get_sequence() + '\n')
    output_sequence_file.write('+\n')
    output_sequence_file.write(record.get_quality() + '\n')

def write_information(record, output_file_formats, output_sequence_file, 
    output_qual_file, qual_format):
    if "fasta" in output_file_formats:
        write_fasta_record(record, output_sequence_file)
    if "qual" in output_file_formats:
        write_qual_record(record, output_qual_file, qual_format)
    if "fastq" in output_file_formats:
        write_fastq_record(record, output_sequence_file)

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

extractable_information = {
    'id': str,
    'length': int,
    'description': str
}

###########
# Classes #
###########
class SeqRecord:

    def __init__(self, seq_id, sequence, description, quality = ""):
        self.id = seq_id
        self.sequence = sequence
        self.quality = quality
        self.description = description
        self.length = len(self.sequence)

    # Getters
    def get_id(self):
        return self.id

    def get_sequence(self):
        return self.sequence

    def get_quality(self):
        return self.quality

    def get_length(self):
        return self.length

    def get_description(self):
        return self.description

    def get(self, category):
        if category == 'id':
            return self.id
        elif category == 'length':
            return self.length
        else:
            string = os.path.basename(__file__) + ': '
            string += category + ' can not be extracted from SeqRecord'
            raise ValueError(string)

    # Other functions
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

    def __init__(self, input_filepath, file_format, constraints):
        self.records = []
        self.conserved_records = []
        with open(input_filepath, 'r') as input_file:
            to_continue = True
            while to_continue:
                record = next_record(input_file, file_format)
                if record != None:
                    self.records.append(record)
                    to_conserve = record.test_conservation(constraints)
                    if to_conserve:
                        self.conserved_records.append(copy.copy(record))
                else:
                    to_continue = False           

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
    def save_conserved_records(self,args):
        if args.custom_extraction_type == 'yes':
            to_extract = args.to_extract[1:-1].split(',')
            with open(args.output_information, 'w') as output_information_file:
                output_information_file.write('\t'.join(to_extract) + '\n')
                for record in self.conserved_records:
                    extracted_info = record.extract_information(to_extract)
                    string_info = [str(info) for info in extracted_info]
                    string = '\t'.join(string_info)
                    output_information_file.write(string + '\n')
        else:
            qual_format = None
            if args.format == 'fasta':
                output_file_formats = ['fasta']
            elif args.format == 'fastq':
                if args.split == 'yes':
                    output_file_formats = ['fasta','qual']
                    qual_format = args.quality_format
                else:
                    output_file_formats = ['fastq']

            with open(args.output_sequence,'w') as output_sequence_file: 
                if "qual" in output_file_formats:
                    output_qual_file = open(args.output_quality, 'w')
                else:
                    output_qual_file = None
                for record in self.conserved_records:
                    write_information(record, output_file_formats,
                        output_sequence_file, output_qual_file, qual_format)
                if "qual" in output_file_formats:
                    output_qual_file.close()

class Constraint:

    def __init__(self, constraint_type, value, constrained_information):
        if not constraints.has_key(constraint_type):
            string = os.path.basename(__file__) + ': '
            string += constraint_type + ' is not a correct type of constraint'
            raise ValueError(string)
        self.raw_constraint_type = constraint_type
        self.type = constraints[constraint_type]

        value_format = extractable_information[constrained_information]
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
def test_input_filepath(input_filepath, tool, file_format):
    if not os.path.exists(input_filepath):
        string = os.path.basename(__file__) + ': '
        string += input_filepath + ' does not exist'
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

def extract_sequence_file(args):
    input_filepath = args.input
    file_format = args.format
    constraints = args.constraint
    formatted_constraints = format_constraints(constraints)

    records = Records(input_filepath, file_format, formatted_constraints)
    records.save_conserved_records(args)
    
    report_filepath = args.report
    with open(report_filepath, 'w') as report_file:
        report_file.write('Input filepath: ' + input_filepath + '\n')

        report_file.write('Information to extract:\n')
        if args.custom_extraction_type == 'yes':
            for info in args.to_extract[1:-1].split(','):
                report_file.write('\t' + info + '\n')
        else:
            report_file.write('\tsequences\n')

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
    parser.add_argument('--format', required=True)
    parser.add_argument('--custom_extraction_type', required=True)
    parser.add_argument('--to_extract')
    parser.add_argument('--output_information')
    parser.add_argument('--split')
    parser.add_argument('--quality_format')
    parser.add_argument('--output_sequence')
    parser.add_argument('--output_quality')
    parser.add_argument('--constraint', action='append')
    parser.add_argument('--report', required=True)
    args = parser.parse_args()

    extract_sequence_file(args)
