#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
from ftplib import FTP
import pickle
import inspect
import json_config_manipulation

###########
# Methods #
###########
def retrieve_gene_cog_mapping_seq_length(cog_info_filepath, seq_length_filepath, gene_cog_mapping_filepath, protein_organism_mapping_filepath):
    cog_info_file = open(cog_info_filepath, 'r')
    
    COGs = {}
    gene_length_file = open(seq_length_filepath,'w')
    prot_organisms = {}
    Organisms_COGs = {}
    for line in cog_info_file.readlines():
        split_line = line[:-2].split(',')
        prot_id = split_line[2]
        organism = split_line[1]
        prot_length = split_line[3]
        COG_id = split_line[6]

        if not prot_organisms.has_key(prot_id):
            prot_organisms[prot_id] = organism
        elif prot_organisms[prot_id] != organism : 
            raise ValueError(os.path.basename(__file__) + ' -- ' + inspect.stack()[1][3] + ": " + prot_id, " already register with a different organism")

        gene_length_file.write(organism.lower() + ':' + prot_id + '\t' + prot_length + '\n')

        COGs.setdefault(COG_id, []).append(organism + '#' + prot_id)

        Organisms_COGs.setdefault(organism, []).append(COG_id)
    gene_length_file.close()
    cog_info_file.close()

    gene_to_COG_file = open(gene_cog_mapping_filepath,'w')
    for COG in COGs:
        gene_to_COG_file.write(COG)
        for prot_id in COGs[COG]:
            gene_to_COG_file.write('\t' + prot_id.upper())
        gene_to_COG_file.write('\n') 
    gene_to_COG_file.close()

    protein_organism_mapping_file = open(protein_organism_mapping_filepath,'w')
    pickle.dump(prot_organisms,protein_organism_mapping_file)
    protein_organism_mapping_file.close()

    return Organisms_COGs

def retrieve_KEGG_COG_mapping(filepath):
    KEGG_COG_mapping_file = open(filepath,'r')
    KEGG_COG_mapping_file_content = KEGG_COG_mapping_file.readlines()
    KEGG_COG_mapping_file.close()

    KEGG_COG_mapping = {}
    for line in KEGG_COG_mapping_file_content:
        split_line = line[:-1].split('\t')
        ko = split_line[0]
        cog = split_line[1:]

        kegg_cog = KEGG_COG_mapping.setdefault(ko, [])
        kegg_cog += cog

    compt = 0
    for k in KEGG_COG_mapping.keys():
        if len(KEGG_COG_mapping[k]) > 1:
            compt += 1 
    print "\t\t", compt,"KEGG categories with multiple COG"

    return KEGG_COG_mapping

def test_KEGG_presence(k, K_categories,KEGG_COG_mapping,K_not_found):
    if k not in K_categories:
        K_categories.append(k)
    if not KEGG_COG_mapping.has_key(k):
        if k not in K_not_found:
            K_not_found.append(k)
        return False
    else : 
        return True

def generation_COG_pathway_mapping(kegg_pathway_mapping_filepath,cog_pathway_mapping_filepath,KEGG_COG_mapping):
    KEGG_pathway_mapping_file = open(kegg_pathway_mapping_filepath,'r')
    COG_pathway_mapping_file = open(cog_pathway_mapping_filepath,'w')
    COG_ko_mapping = {}
    for line in  KEGG_pathway_mapping_file.readlines():
        split_line = line[:-1].split('\t')
        ko = split_line[0]
        ks = split_line[1:]
        module_string = ''
        for k in ks :
            if test_KEGG_presence(k, K_categories,KEGG_COG_mapping,K_not_found):
                module_string += '\t' + KEGG_COG_mapping[k][0]
                for cog in KEGG_COG_mapping[k]:
                    COG_ko_mapping.setdefault(cog, []).append(ko)
        if module_string != '':
            COG_pathway_mapping_file.write(ko + module_string + '\n')
    COG_pathway_mapping_file.close()
    KEGG_pathway_mapping_file.close()
    return COG_ko_mapping

def transform_combination_from_KEGG_to_COG(module):
    #print submodule, type(submodule), submodule.m_fJoin
    if isinstance(module,str):
        #raise ValueError(os.path.basename(__file__) + ' -- ' + inspect.stack()[1][3] + ': invalid KEGG category for ' + submodule)
        return ''
    if module._isleaf():
        k = module.m_pToken
        if test_KEGG_presence(k, K_categories,KEGG_COG_mapping,K_not_found):
            return KEGG_COG_mapping[k][0]
        else : 
            return ''
    else :
        #s = '('
        s = ''
        module_str = str(module)
        for submodule in module.m_pToken:
            pos = module_str.find(str(submodule))
            #print module_str, module_str[pos-1]
            kegg_to_cog_str = transform_combination_from_KEGG_to_COG(submodule)
            if kegg_to_cog_str != '':
                if s == '':
                    s += '('
                else :
                    s += module_str[pos-1]
                s += kegg_to_cog_str
        if s != '':
            s += ')'
        #print module, s
        return s

def generation_COG_module_mapping(input_dirpath, output_dirpath,KEGG_COG_mapping):
    # modulec
    KEGG_module_mapping_file = open(input_dirpath + '/modulec', 'r')
    module_mapping_file = open(output_dirpath + '/modulec','w')
    for line in KEGG_module_mapping_file.readlines():
        split_line = line[:-1].split('\t')
        module = split_line[0]
        ks = split_line[1:]
        module_string = ''
        for k in ks :
            if test_KEGG_presence(k, K_categories,KEGG_COG_mapping,K_not_found):
                module_string += '\t' + KEGG_COG_mapping[k][0]
        if module_string != '':
            module_mapping_file.write(module + module_string + '\n')
    module_mapping_file.close()
    KEGG_module_mapping_file.close()

    # modulep
    KEGG_module_mapping = pathway.open(open(input_dirpath + '/modulep'))
    module_mapping_file = open(output_dirpath + '/modulep','w')
    for module in KEGG_module_mapping:
        module_id = module.m_strID
        module_detail = module.m_pPathway.m_pToken
        module_mapping_file.write(module_id)
        for submodule in module_detail:
            kegg_to_cog_str = transform_combination_from_KEGG_to_COG(submodule)
            if kegg_to_cog_str != '':
                module_mapping_file.write('\t' + kegg_to_cog_str)
        module_mapping_file.write('\n')
    module_mapping_file.close()
    KEGG_module_mapping_file.close()

def retrieve_organism_pathway(taxpc_filepath,Organisms_COGs,COG_ko_mapping):
    	taxpc_file = open(taxpc_filepath,'w')
    	for orga in Organisms_COGs.keys():
       		ko_list = []
        	for cog in Organisms_COGs[orga]:
            		cog_ko = COG_ko_mapping.get(cog)
            		if cog_ko != None :
               			ko_list += cog_ko
        	if ko_list != []:
            		taxpc_file.write(orga)
            		for ko in set(ko_list): #transforming into set to remove duplicates
               			taxpc_file.write('\t' + ko + '#1')
            		taxpc_file.write('\n')
    	taxpc_file.close()

def complete_category_information(map_kegg_filepath, cogname_filepath, map_cog_filepath):
    	map_kegg_file = open(map_kegg_filepath,'r')
    	map_kegg = {}
    	for line in map_kegg_file.readlines():
        	split_line = line[:-1].split('\t')
        	detail = ' / '.join(split_line[1:])
        	map_kegg.setdefault(split_line[0], detail)
    	map_kegg_file.close()

    	cog_detail_file = open(cogname_filepath,'r')
    	for line in cog_detail_file.readlines()[1:]:
        	split_line = line[:-1].split('\t')
        	detail = ' / '.join(split_line[2:])
        	map_kegg.setdefault(split_line[0], detail)
    	cog_detail_file.close()

    	map_kegg_file = open(map_cog_filepath,'w')
    	for cat, detail in map_kegg.items():
        	map_kegg_file.write(cat + "\t" + detail + "\n")
    	map_kegg_file.close()

def extract_COG_module_pathway_mapping(input_filepath):
	if not os.path.exists(input_filepath):
		print "Directory content"
		print os.listdir(os.path.dirname(input_filepath))
		raise ValueError(os.path.basename(__file__) + ": " + input_filepath + " not found")
	
    	COG_module_pathway_mapping = {}
    	COG_module_pathway_mapping_file = open(input_filepath, 'r')
    	for line in COG_module_pathway_mapping_file.readlines():
        	split_line = line[:-1].split('\t')
        	module = split_line[0]
        	module_list = COG_module_pathway_mapping.setdefault(module, []) 
        	module_list += split_line[1:]
    	COG_module_pathway_mapping_file.close()
    	return COG_module_pathway_mapping

##############################################
# Formate COG database with KEGG information #
##############################################
if __name__ == '__main__':
    HUMAnN_dirpath = '/src/lib/HUMAnN/'

    directory_information = json_config_manipulation.load_json_config_file('/src/global_information.json')
    cog_dirpath = json_config_manipulation.search_key_in_config_params(directory_information,"raw_data_dir")
    cog_extracted_data_dirpath = json_config_manipulation.search_key_in_config_params(directory_information,"extracted_data_dir")
    COG_KEGG_module_pathway_dir = json_config_manipulation.search_key_in_config_params(directory_information,"kegg_formatted_dir")
    os.system('mkdir ' + COG_KEGG_module_pathway_dir)

    os.system('cp ' + cog_extracted_data_dirpath + '/genels.gz ' + COG_KEGG_module_pathway_dir)
    os.system('cp ' + cog_extracted_data_dirpath + '/koc.gz ' + COG_KEGG_module_pathway_dir)

    # use HUMAnN code
    sys.path.append(HUMAnN_dirpath + 'src')
    import pathway

    # Retrieve KEGG informations
    KEGG_information_dirpath = HUMAnN_dirpath + 'data/'

    # Formate COG data with KEGG module/pathways
    #Organisms_COGs = retrieve_gene_cog_mapping_seq_length(cog_dirpath + "cog2003-2014.csv", COG_KEGG_module_pathway_dir + 'genels', COG_KEGG_module_pathway_dir + 'koc', COG_KEGG_module_pathway_dir + 'protein_organism_mapping')
    KEGG_COG_mapping = retrieve_KEGG_COG_mapping(KEGG_information_dirpath + 'cogc')

    K_not_found = []
    K_categories = []
    COG_ko_mapping = generation_COG_pathway_mapping(KEGG_information_dirpath + '/keggc', COG_KEGG_module_pathway_dir + 'keggc',KEGG_COG_mapping)
    generation_COG_module_mapping(KEGG_information_dirpath, COG_KEGG_module_pathway_dir,KEGG_COG_mapping)

    K_not_found_file = open(COG_KEGG_module_pathway_dir + '/kegg_not_found','w')
    for k in K_not_found:
        K_not_found_file.write(k + '\n')
    K_not_found_file.close()
    print "\t\t", len(K_not_found), "/", len(K_categories),"KEGG categories not found"

    retrieve_organism_pathway(COG_KEGG_module_pathway_dir + 'taxpc', Organisms_COGs,COG_ko_mapping)
    complete_category_information(KEGG_information_dirpath + '/map_kegg.txt', cog_dirpath + 'cognames2003-2014.tab', COG_KEGG_module_pathway_dir + 'map_kegg.txt')

    # Remove useless files
    os.system('rm -r ' + HUMAnN_dirpath)

