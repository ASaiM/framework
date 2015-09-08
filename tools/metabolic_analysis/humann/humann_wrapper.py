#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import pickle
import argparse

def generate_humann_param_file(sconstruct_filepath, args, data_dir):
    sconstruct_file = open(sconstruct_filepath,"w")

    #######################
    # General information #
    #######################
    sconstruct_file.write("from humann import *\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("import logging\n")
    sconstruct_file.write("import logging.handlers\n")
    sconstruct_file.write("import re\n")
    sconstruct_file.write("\n")

    # Directory name scanned for input files
    if args.cog_extracted_data == 'yes':
        sconstruct_file.write("c_strDirInput = \"" + data_dir + '/' + os.path.split(args.input)[0] + "/formatted\"\n")
    else:
        sconstruct_file.write("c_strDirInput = \"" + data_dir + '/' + os.path.split(args.input)[0] + "/\"\n")

    # Directory into which all output files are placed
    tmp_output_dir = os.path.split(args.input)[0] + '/temporary_humann_output/'
    if not os.path.exists(tmp_output_dir):
        os.makedirs(tmp_output_dir)
    sconstruct_file.write("c_strDirOutput = \"" + tmp_output_dir + "\"\n")

    # Filename from which metadata annotations are read; can be excluded
    #sconstruct_file.write("c_strInputMetadata                  = c_strDirInput + \"/hmp_metadata.dat\"\n")

    # Optional: MetaCyc distribution tarball, will be used for pathways if present
    sconstruct_file.write("c_strInputMetaCyc = \"\" # c_strDirInput + \"/meta.tar.gz\"\n")
    sconstruct_file.write("c_strVersionMetaCyc = \"14.6\"\n")

    # Optional: MetaCyc distribution tarball, will be used for pathways if present
    # Note: Should build synthetic communities in the \"synth\" subdirectory first if enabled
    sconstruct_file.write("c_fMocks = False\n")

    # Optional: Generate results on a per-organism (rather than whole-community) basis
    sconstruct_file.write("c_fOrg = False\n")

    # Filename into which all processing steps are logged for provenance tracking
    sconstruct_file.write("logging.basicConfig( filename = \"provenance.txt\", level = logging.INFO,\n")
    sconstruct_file.write("     format = '%(asctime)s %(levelname)-8s %(message)s' )\n")
    sconstruct_file.write("c_logrFileProvenanceTxt = logging.getLogger( )\n")
    sconstruct_file.write("\n")

    ####################
    # Input processors #
    ####################
    # Each input processor takes up to eight arguments:
    #    The input filename extension targeted by the processor
    #    The output numerical type tag (identifying the type of data; see README.text)
    #    The output textual processor label (identifying the way in which the data were generated; see README.text)
    #    The processing script for this input type\n")
    #    A list of zero or more additional files provided on the command line to the processing script
    #    A list of zero or more non-file arguments provided on the command line to the script
    #    True if the processor is for input files (and not intermediate files
    #    True if the processor's output should be gzip compressed
    sconstruct_file.write("c_apProcessors = [\n")

    # Default: txt or gzipped txt blastx data
    sconstruct_file.write(" CProcessor( \".dat\",\"00\",\"hit\",c_strProgBlast2Hits,[],[],True,True ),\n")
    #sconstruct_file.write(" CProcessor( \".txt.gz\",\"00\",\"hit\", c_strProgBlast2Hits,[],[],True,True ),\n")

    # Default: mapped bam data
    #sconstruct_file.write(" CProcessor( \".bam\",\"00\",\"hit\",c_strProgBam2Hits,[],[],True,True ),\n")

    # Default: multiple pre-quantified gene identifiers in tab-delimited text
    # Note that for unfortunate technical reasons, the output directory, numerical type tag
    # and textual processor label must match the script's command line arguments as shown
    #sconstruct_file.write(" CProcessor( \".pcl\",\"01\",\"hit-keg\",c_strProgTSV2Hits,[],[c_strDirOutput + \"/\", \"_01-hit-keg\" + c_strSuffixOutput], True ),\n")
    #sconstruct_file.write(" CProcessor( \".tsv\",\"01\",\"hit-keg\",c_strProgTSV2Hits,[],[c_strDirOutput + \"/\", \"_01-hit-keg\" + c_strSuffixOutput], True ),\n")
    #sconstruct_file.write(" CProcessor( \".csv\",\"01\",\"hit-keg\",c_strProgTSV2Hits,[],[c_strDirOutput + \"/\", \"_01-hit-keg\" + c_strSuffixOutput], True ),\n")
    
    ########################
    # Non-input processors #
    ########################
    # Each non-input processor takes up to six arguments:
    #    The input numerical type tag
    #    The output numerical type tag
    #    The output textual processor label
    #    The processing script
    #    A list of zero or more files provided on the command line to the processing script
    #    A list of zero or more non-file arguments provided on the command line to the script

    last_id=None

    # KEGG
    if args.ko_abundance== 'yes':
        # hits -> enzymes

        # Generate KO abundances from BLAST hits
        sconstruct_file.write(" CProcessor( \"00\",\"01\",\"ko\",c_strProgHits2Enzymes,[c_strFileKOC, c_strFileGeneLs],[str( c_fOrg )] ),\n")
        sconstruct_file.write(" CProcessor( \"01\",\"01b\",\"cat\",c_strProgCat,[] ),\n")

        # enzymes -> pathways
        # Generate KEGG pathway assignments from KOs
        if args.kegg_pathway == 'yes':
            sconstruct_file.write(" CProcessor( \"01\",\"02a\",\"mpt\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileKEGGC] ),\n")
            last_id = "02a"

        # Generate KEGG module assignments from KOs
        if args.kegg_module == 'yes':
            sconstruct_file.write(" CProcessor( \"01\",\"02a\",\"mpm\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileModuleC] ),\n")
            last_id = "02a"

    # MetaCyc
    if args.metacyc_enzyme == 'yes':
        # hits -> enzymes
        # Generate MetaCyc enzyme abundances from BLAST hits
        # Enable only if c_strInputMetaCyc is defined above
        sconstruct_file.write(" CProcessor( \"00\",\"11\",\"mtc\",c_strProgHits2Metacyc,[c_strFileMCC] ),\n")

        # enzymes -> pathways
        # Generate MetaCyc pathway assignments from enzymes
        if args.metacyc_pathway == 'yes':
            sconstruct_file.write(" CProcessor( \"11\",\"02a\",\"mpt\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileMCPC] ),\n")
            last_id = "02a"

    # MetaRep
    if args.metarep == 'yes' :
        # hits -> metarep
        # Optional: Generate a METAREP input file from BLAST hits
        sconstruct_file.write(" CProcessor( \"00\",\"99\",\"mtr\",c_strProgHits2Metarep,[c_strFileGeneLs] ),\n")

    if last_id != None:
        # taxonomic provenance
        if args.taxonomic_limitation == 'yes':
            sconstruct_file.write(" CProcessor( \"" + last_id + "\",\"02b\",\"cop\",c_strProgTaxlim,[c_strFileTaxPC, c_strFileKOC] ),\n")
            last_id = "02b"

        # smoothing
        # Smoothing is disabled by default with the latest KEGG Module update
        if args.wb_smoothing == 'yes':
            sconstruct_file.write(" CProcessor( \"" + last_id + "\",\"03a\",\"wbl\",c_strProgSmoothWB,[c_strFilePathwayC] ),\n")
        else:
            sconstruct_file.write(" CProcessor( \"" + last_id + "\",\"03a\",\"nul\",c_strProgCat,[] ),\n")
        last_id = "03a"

        # gap filling
        if args.gap_filling == 'yes':
            sconstruct_file.write(" CProcessor( \"" + last_id + "\",\"03b\",\"nve\",c_strProgGapfill,[c_strFilePathwayC] ),\n")
            last_id = "03b"

        # COVERAGE
        if args.coverage == 'yes':
            sconstruct_file.write(" CProcessor( \"" + last_id + "\",\"03c\",\"nve\",c_strProgPathCov,[c_strFilePathwayC, c_strFileModuleP] ),\n")
            if args.low_coverage_elimination == 'yes':
                sconstruct_file.write(" CProcessor( \"03c\",\"04a\",\"xpe\",c_strProgPathCovXP,[c_strProgXipe] ),\n")

        # ABUNDANCE
        if args.abundance_computation == 'yes':
            sconstruct_file.write(" CProcessor( \"" + last_id + "\",\"04b\",\"nve\",c_strProgPathAb,[c_strFilePathwayC, c_strFileModuleP] ),\n")

    sconstruct_file.write("]\n")
    
    ####################
    # Piped finalizers #
    ####################
    # A chain of piped finalizers runs on each file produced by the processing
    # pipeline that is _not_ further processed; in other words, the coverage 04a and
    # abundance 04b and 01b files.  Each finalizer consists of up to three parts:
    #    An optional regular expression that must match filenames on which it is run
    #    The processing script
    #    A list of zero or more files provided on the command line to the processing script
    sconstruct_file.write("c_aastrFinalizers = [\n")
    sconstruct_file.write(" [None, c_strProgZero],\n")
    sconstruct_file.write(" [None, c_strProgFilter, [c_strFilePathwayC, c_strFileModuleP]],\n")
    sconstruct_file.write(" [r'0(1")
    if last_id != None:
        if args.coverage == '' :
            if args.low_coverage_elimination == 'yes':
                sconstruct_file.write("|(4a)")
            else:
                sconstruct_file.write("|(3c)")
        if args.abundance_computation == 'yes':
            sconstruct_file.write("|(4b)'")
    sconstruct_file.write(")', c_strProgNormalize],\n")
    sconstruct_file.write(" [None, c_strProgEco],\n")
    #sconstruct_file.write("    [None, c_strProgMetadata],\n")#, [c_strInputMetadata]],\n")
    sconstruct_file.write("]\n")
    sconstruct_file.write("\n")

    ###################
    # Piped exporters #
    ###################
    # A chain of piped exporters runs on each final file produced in the previous step.\n")
    # Each exporter consists of up to three parts:\n")
    #    An optional regular expression that must match filenames on which it is run\n")
    #    An array containing:\n")
    #        The processing script\n")
    #        An array of zero or more files provided on the command line to the processing script\n")
    #    A required tag for the file to differentiate it from other HUMAnN outputs\n")
    if args.graphlan_export == 'yes':
        sconstruct_file.write("c_aastrExport = [\n")
        sconstruct_file.write(" [r'04b.*', [[c_strProgGraphlanTree, [c_strFileGraphlan]]], \"-graphlan_tree\"],\n")
        sconstruct_file.write(" [r'04b.*', [[c_strProgGraphlanRings, [c_strFileGraphlan]]], \"-graphlan_rings\"],\n")
        sconstruct_file.write("]\n")

    sconstruct_file.write("\n")
    sconstruct_file.write("main( globals( ) )\n")

    return tmp_output_dir

def formate_blast_output(input_report_filepath, 
    refseq_orga_id_corresp_filepath):
    if not os.path.exists(refseq_orga_id_corresp_filepath):
        string = refseq_orga_id_corresp_filepath + " does not exist\n"
        dir_path = os.path.split(refseq_orga_id_corresp_filepath)[0]
        string += dir_path + "\n"
        string += str(os.listdir(dir_path))
        raise ValueError(string)

    with open(refseq_orga_id_corresp_filepath,'r') as refseq_orga_id_corresp_file:
        refseq_organism_id_corres = pickle.load(refseq_orga_id_corresp_file)

    dirpath, filename = os.path.split(os.path.abspath(input_report_filepath))
    output_report_dirpath = dirpath + '/formatted/'
    if not os.path.exists(output_report_dirpath):
        os.mkdir( output_report_dirpath)
    transfo_function = lambda s: s.split('|')[3].split('.')[0]

    with open(input_report_filepath, 'r') as input_report_file:
        with open(output_report_dirpath + filename,'w') as output_report_file:
            for row in input_report_file:
                split_row = row[:-1].split('\t')
                target = transfo_function(split_row[1])

                if not refseq_organism_id_corres.has_key(target):
                    string = "Unknow cog sequence:" + target
                    raise ValueError(string)
                split_row[1] = refseq_organism_id_corres[target]
                output_report_file.write('\t'.join(split_row) + '\n')

def generate_outputs(tmp_output_dir,args):
    pass


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--humann_dir', required=True)
    parser.add_argument('--cog_extracted_data')
    parser.add_argument('--ko_abundance', required=True)
    parser.add_argument('--kegg_pathway', required=True)
    parser.add_argument('--kegg_module', required=True)
    parser.add_argument('--metarep', required=True)
    parser.add_argument('--metacyc_enzyme', required=True)
    parser.add_argument('--metacyc_pathway', required=True)
    parser.add_argument('--taxonomic_limitation', required=True)
    parser.add_argument('--wb_smoothing', required=True)
    parser.add_argument('--gap_filling', required=True)
    parser.add_argument('--coverage', required=True)
    parser.add_argument('--low_coverage_elimination', required=True)
    parser.add_argument('--abundance_computation', required=True)
    parser.add_argument('--graphlan_export', required=True)
    parser.add_argument('--kegg_ko_abundance_file')
    parser.add_argument('--cog_abundance_file') 
    parser.add_argument('--kegg_pathway_coverage_file')
    parser.add_argument('--kegg_pathway_abundance_file')
    parser.add_argument('--kegg_module_coverage_file')
    parser.add_argument('--kegg_module_abundance_file')
    parser.add_argument('--metacyc_pathway_coverage_file')
    parser.add_argument('--metacyc_pathway_abundance_file')
    parser.add_argument('--kegg_pathway_abundance_graphlan_tree')
    parser.add_argument('--kegg_pathway_abundance_graphlan_rings')
    parser.add_argument('--kegg_module_abundance_graphlan_tree')
    parser.add_argument('--kegg_module_abundance_graphlan_rings')
    parser.add_argument('--metacyc_pathway_abundance_graphlan_tree')
    parser.add_argument('--metacyc_pathway_abundance_graphlan_rings')

    args = parser.parse_args()

    if args.cog_extracted_data == 'yes':
        formate_blast_output(args.input,
            args.humann_dir + '/cog_data/refseq_orga_id_correspondance')
        command = 'cp ' + args.humann_dir + '/cog_data/* ' 
        command += args.humann_dir + '/data'
        os.system(command)

    current_directory = os.getcwd()

    os.chdir(args.humann_dir)
    tmp_output_dir = generate_humann_param_file('SConstruct', args, current_directory)
    os.system("scons")
    #os.system('ls data/')
    #print output_dir
    #os.system('ls ' + output_dir)
    os.chdir(current_directory)

    generate_outputs(tmp_output_dir,args)