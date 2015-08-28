#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import pickle

import json_config_manipulation

###########
# Methods #
###########
def extract_info_from_cog_table(cog_seq_name_correspondance_filepath):
	if not os.path.exists(cog_seq_name_correspondance_filepath):
		raise ValueError(os.path.basename(__file__) + ": " + cog_seq_name_correspondance_filepath + " does not exist")
	
	cog_seq_name_correspondance_file = open(cog_seq_name_correspondance_filepath,'r')
	
	detailed_informations = {}
	seqid_organism_correspondance = {}
	for line in cog_seq_name_correspondance_file.readlines():
		split_line = line[:-1].split(',')
		organism = split_line[1]
		seq_id = split_line[2]
		prot_length = split_line[3]
		cog = split_line[6]
		
		detailed_informations.setdefault(cog, {}).setdefault(organism,{}).setdefault(seq_id,prot_length)
		
		if seqid_organism_correspondance.has_key(seq_id) and organism != seqid_organism_correspondance[seq_id]:
			raise ValueError(os.path.basename(__file__) + ": " + seq_id + " already registered in seqid_organism_correspondance for a different organism (" + seqid_organism_correspondance[seq_id] + ') than here (' + organism + ')')
		seqid_organism_correspondance.setdefault(seq_id,organism)

	cog_seq_name_correspondance_file.close()
	return detailed_informations,seqid_organism_correspondance

def save_cog_detailed_informations (detailed_informations, dirpath):
	gene_length_file = open(dirpath + '/genels','w')
	gene_to_COG_file = open(dirpath + '/koc','w')

	for cog_name in detailed_informations:
		gene_to_COG_file.write(cog_name)
		for organism in detailed_informations[cog_name]:
			for seq_id in detailed_informations[cog_name][organism]:
				gene_length_file.write(organism.lower() + ':' + seq_id + '\t' + detailed_informations[cog_name][organism][seq_id] + '\n') 
				gene_to_COG_file.write('\t' + organism.upper() + '#' + seq_id.upper())
				gene_to_COG_file.write('\n')

	gene_length_file.close()
	gene_to_COG_file.close()

	os.system('gzip ' + dirpath + '/genels')
	os.system('gzip ' + dirpath + '/koc')
	print os.listdir(dirpath)

def make_refseq_organism_id_correspondance(seqid_organism_correspondance, prot_tab_filepath, refseq_organism_id_correspondance_filepath):
	refseq_organism_id_correspondance = {}
	with open(prot_tab_filepath,'r') as prot_tab_file:
		for line in prot_tab_file.readlines():
			split_line = line[:-1].split('\t')
			seq_id = split_line[0]
			refseq = split_line[1]

			if not seqid_organism_correspondance.has_key(seq_id):
				raise ValueError(os.path.basename(__file__) + ": " + seq_id + " not registered in seqid_organism_correspondance")
			organism = seqid_organism_correspondance[seq_id]

			combination = organism.lower() + ':' + seq_id
			if refseq_organism_id_correspondance.has_key(refseq) and combination != refseq_organism_id_correspondance[refseq]:
				raise ValueError(os.path.basename(__file__) + ": " + refseq + " already registered in refseq_organism_id_correspondance for a different organism (" + refseq_organism_id_correspondance[refseq]+ ') than here (' + combination + ')')
			else:
				refseq_organism_id_correspondance.setdefault(refseq,combination)

	with open(refseq_organism_id_correspondance_filepath, 'w') as refseq_organism_id_correspondance_file:
		pickle.dump(refseq_organism_id_correspondance,refseq_organism_id_correspondance_file)	 
	
if __name__ == '__main__':
	directory_information = json_config_manipulation.load_json_config_file('/src/global_information.json')
	raw_data_dirpath = json_config_manipulation.search_key_in_config_params(directory_information,"raw_data_dir")
	extracted_data_dirpath = json_config_manipulation.search_key_in_config_params(directory_information,"extracted_data_dir")
	if not os.path.exists(extracted_data_dirpath):
		os.system('mkdir -p ' + extracted_data_dirpath)
	cog_detailed_info,seqid_organism_correspondance = extract_info_from_cog_table(raw_data_dirpath + 'cog2003-2014.csv')
	save_cog_detailed_informations(cog_detailed_info, extracted_data_dirpath)
	make_refseq_organism_id_correspondance(seqid_organism_correspondance, raw_data_dirpath + 'prot2003-2014.tab', extracted_data_dirpath + 'refseq_organism_id_correspondance')

	

