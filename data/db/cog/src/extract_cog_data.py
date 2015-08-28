#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import pickle

###########
# Methods #
###########
def extract_info_from_cog_table(cog_seq_name_correspondance_filepath):
    if not os.path.exists(cog_seq_name_correspondance_filepath):
        string = os.path.basename(__file__) + ": " 
        string += cog_seq_name_correspondance_filepath + " does not exist"
        raise ValueError(string)
    
    cog_seq_name_correspondance_file = open(
        cog_seq_name_correspondance_filepath,'r')
    
    detailed_informations = {}
    seqid_organism_correspondance = {}
    for line in cog_seq_name_correspondance_file.readlines():
        split_line = line[:-1].split(',')
        organism = split_line[1]
        seq_id = split_line[2]
        prot_length = split_line[3]
        cog = split_line[6]
        
        detailed_informations.setdefault(cog, {}).setdefault(organism,
            {}).setdefault(seq_id,prot_length)
        
        test = seqid_organism_correspondance.has_key(seq_id) 
        test = test and organism != seqid_organism_correspondance[seq_id]
        if test:
            string = os.path.basename(__file__) + ": " + seq_id 
            string += " already registered in seqid_organism_correspondance for"
            string += " a different organism (" 
            string += seqid_organism_correspondance[seq_id] + ') than here (' 
            string += organism + ')'
            raise ValueError(string)
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
                string = organism.lower() + ':' + seq_id + '\t' 
                string += detailed_informations[cog_name][organism][seq_id] 
                string += '\n'
                gene_length_file.write(string) 
                string = '\t' + organism.upper() + '#' + seq_id.upper() + '\n'
                gene_to_COG_file.write(string)

    gene_length_file.close()
    gene_to_COG_file.close()

    os.system('gzip -f ' + dirpath + '/genels')
    os.system('gzip -f ' + dirpath + '/koc')
    print os.listdir(dirpath)

def make_refseq_organism_id_correspondance(seqid_organism_correspondance, 
    prot_tab_filepath, refseq_orga_id_corres_filepath):
    refseq_orga_id_corresp = {}
    with open(prot_tab_filepath,'r') as prot_tab_file:
        for line in prot_tab_file.readlines():
            split_line = line[:-1].split('\t')
            seq_id = split_line[0]
            refseq = split_line[1]

            if not seqid_organism_correspondance.has_key(seq_id):
                string = os.path.basename(__file__) + ": " + seq_id 
                string += " not registered in seqid_organism_correspondance"
                raise ValueError(string)
            organism = seqid_organism_correspondance[seq_id]

            combination = organism.lower() + ':' + seq_id
            test = refseq_orga_id_corresp.has_key(refseq) 
            test = test and (combination != refseq_orga_id_corresp[refseq])
            if test:
                string = os.path.basename(__file__) + ": " + refseq 
                string += " already registered in " 
                string += "refseq_orga_id_correspondance for a different " 
                string += "organism (" + refseq_orga_id_corresp[refseq]
                string += ') than here (' + combination + ')'
                raise ValueError(string)
            else:
                refseq_orga_id_corresp.setdefault(refseq,combination)

    with open(refseq_orga_id_corres_filepath, 'w') as refseq_orga_id_corres_file:
    	pickle.dump(refseq_orga_id_corresp, refseq_orga_id_corres_file)	 
	
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--raw_data_dir', required=True)
    parser.add_argument('--extracted_data_dir', required=True)
    args = parser.parse_args()

    raw_data_dirpath = args.raw_data_dir
    extracted_data_dirpath = args.extracted_data_dir

    if not os.path.exists(extracted_data_dirpath):
        os.system('mkdir -p ' + extracted_data_dirpath)

    cog_info,seqid_orga_correspondance = extract_info_from_cog_table(
        raw_data_dirpath + 'cog2003-2014.csv')
    save_cog_detailed_informations(cog_info, extracted_data_dirpath)
    make_refseq_organism_id_correspondance(seqid_orga_correspondance, 
        raw_data_dirpath + 'prot2003-2014.tab', 
        extracted_data_dirpath + 'refseq_orga_id_correspondance')

