#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import pickle
import argparse

def generate_humann_param_file(sconstruct_filepath, args, data_dir):
    sconstruct_file = open(sconstruct_filepath,"w")

    sconstruct_file.write("from humann import *\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("import logging\n")
    sconstruct_file.write("import logging.handlers\n")
    sconstruct_file.write("import re\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("def isexclude( strInput ):\n")
    sconstruct_file.write(" \n")
    sconstruct_file.write("#    Given the name of an input file, return True if it should be skipped.  Useful for\n")
    sconstruct_file.write("#    matching only a specific set (by inclusion) or removing a specific set (by exclusion)\n")
    sconstruct_file.write("#    using regular expression patterns or raw filenames.\n")
    sconstruct_file.write(" \n")
    sconstruct_file.write("\n")
    sconstruct_file.write("# Example: exclude any file whose filename ends with \".example\".\n")
    sconstruct_file.write("#    if re.search( r'\.example$', strInput ):\n")
    sconstruct_file.write("#        return True\n")
    sconstruct_file.write("# By default, exclude nothing\n")
    sconstruct_file.write(" return (\n")
    sconstruct_file.write("     False\n")
    sconstruct_file.write("# Example: exclude any file whose filename does not contain \"example\".\n")
    sconstruct_file.write("#        ( strInput.find( \"example\" ) < 0 )\n")
    sconstruct_file.write("     )\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("# Directory name scanned for input files\n")
    sconstruct_file.write("c_strDirInput                        = \"" + data_dir + '/' + os.path.split(args.input)[0] + "/formatted\"\n")
    sconstruct_file.write("# Directory into which all output files are placed\n")
    sconstruct_file.write("c_strDirOutput                       = \"" + data_dir + '/' + os.path.split(args.output)[0] + "\"\n")
    #sconstruct_file.write("# Filename from which metadata annotations are read; can be excluded (see below)\n")
    #sconstruct_file.write("\n")
    #sconstruct_file.write("c_strInputMetadata                  = c_strDirInput + \"/hmp_metadata.dat\"\n")
    sconstruct_file.write("# Optional: MetaCyc distribution tarball, will be used for pathways if present\n")
    sconstruct_file.write("c_strInputMetaCyc                    = \"\" # c_strDirInput + \"/meta.tar.gz\"\n")
    sconstruct_file.write("c_strVersionMetaCyc                  = \"14.6\"\n")
    sconstruct_file.write("# Optional: Generate synthetic community performance descriptors\n")
    sconstruct_file.write("# Note: Should build synthetic communities in the \"synth\" subdirectory first if enabled\n")
    sconstruct_file.write("c_fMocks                         = False\n")
    sconstruct_file.write("# Optional: Generate results on a per-organism (rather than whole-community) basis\n")
    sconstruct_file.write("c_fOrg                               = False\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("# Filename into which all processing steps are logged for provenance tracking\n")
    sconstruct_file.write("logging.basicConfig( filename = \"provenance.txt\", level = logging.INFO,\n")
    sconstruct_file.write("     format = '%(asctime)s %(levelname)-8s %(message)s' )\n")
    sconstruct_file.write("c_logrFileProvenanceTxt       = logging.getLogger( )\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("c_apProcessors                       = [\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Default: txt or gzipped txt blastx data\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Each input processor takes up to eight arguments:\n")
    sconstruct_file.write("#    The input filename extension targeted by the processor\n")
    sconstruct_file.write("#    The output numerical type tag (identifying the type of data; see README.text)\n")
    sconstruct_file.write("#    The output textual processor label (identifying the way in which the data were generated; see README.text)\n")
    sconstruct_file.write("#    The processing script for this input type\n")
    sconstruct_file.write("#    A list of zero or more additional files provided on the command line to the processing script\n")
    sconstruct_file.write("#    A list of zero or more non-file arguments provided on the command line to the script\n")
    sconstruct_file.write("#    True if the processor is for input files (and not intermediate files)\n")
    sconstruct_file.write("#    True if the processor's output should be gzip compressed\n")
    sconstruct_file.write(" CProcessor( \".txt\",\"00\",\"hit\",c_strProgBlast2Hits,[],[],True,True ),\n")
    sconstruct_file.write(" CProcessor( \".txt.gz\",\"00\",\"hit\", c_strProgBlast2Hits,[],[],True,True ),\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Default: mapped bam data\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write(" CProcessor( \".bam\",\"00\",\"hit\",c_strProgBam2Hits,[],[],True,True ),\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Default: multiple pre-quantified gene identifiers in tab-delimited text\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Note that for unfortunate technical reasons, the output directory, numerical type tag,\n")
    sconstruct_file.write("# and textual processor label must match the script's command line arguments as shown.  \n")
    sconstruct_file.write(" CProcessor( \".pcl\",\"01\",\"hit-keg\",c_strProgTSV2Hits,[],[c_strDirOutput + \"/\", \"_01-hit-keg\" + c_strSuffixOutput], True ),\n")
    sconstruct_file.write(" CProcessor( \".tsv\",\"01\",\"hit-keg\",c_strProgTSV2Hits,[],[c_strDirOutput + \"/\", \"_01-hit-keg\" + c_strSuffixOutput], True ),\n")
    sconstruct_file.write(" CProcessor( \".csv\",\"01\",\"hit-keg\",c_strProgTSV2Hits,[],[c_strDirOutput + \"/\", \"_01-hit-keg\" + c_strSuffixOutput], True ),\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Example: bzipped mapx data\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("#    CProcessor( \".mapx.bz2\",\"00\",\"hit\",c_strProgBlast2Hits,[],[\"mapx\"], True,True ),\n")
    sconstruct_file.write("# Keep just the top 20 hits and nothing above 90% identity (e.g. for evaluation of the synthetic communities)\n")
    sconstruct_file.write("#    CProcessor( \".mapx.gz\",\"00\",\"htt\",c_strProgBlast2Hits,[],[\"mapx\", \"0.9\", \"20\"], True,True ),\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Example: gzipped mblastx data\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("#    CProcessor( \".mblastx.gz\",\"00\",\"hit\", c_strProgBlast2Hits,[],[\"mblastx\"],True,True ),\n")
    sconstruct_file.write("# Keep nothing above 95% identity (e.g. for evaluation of the synthetic communities)\n")
    sconstruct_file.write("#    CProcessor( \".mblastx.gz\",\"00\",\"htt\",c_strProgBlast2Hits,[],[\"mblastx\", \"0.95\"],True,True ),\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("#------------------------------------------------------------------------------ \n")
    sconstruct_file.write("\n")
    sconstruct_file.write("# Each non-input processor takes up to six arguments:\n")
    sconstruct_file.write("#    The input numerical type tag\n")
    sconstruct_file.write("#    The output numerical type tag\n")
    sconstruct_file.write("#    The output textual processor label\n")
    sconstruct_file.write("#    The processing script\n")
    sconstruct_file.write("#    A list of zero or more files provided on the command line to the processing script\n")
    sconstruct_file.write("#    A list of zero or more non-file arguments provided on the command line to the script\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# hits -> enzymes\n")
    sconstruct_file.write("#===============================================================================\n")
    
    sconstruct_file.write("# Generate KO abundances from BLAST hits\n")
    if args.ko_abundance== 'true':
        sconstruct_file.write(" CProcessor( \"00\",\"01\",\"cog\",c_strProgHits2Enzymes,[c_strFileKOC, c_strFileGeneLs],[str( c_fOrg )] ),\n")
        sconstruct_file.write(" CProcessor( \"01\",\"01b\",\"cat\",c_strProgCat,[] ),\n")
    else:
        sconstruct_file.write("#CProcessor( \"00\",\"01\",\"cog\",c_strProgHits2Enzymes,[c_strFileKOC, c_strFileGeneLs],[str( c_fOrg )] ),\n")
        sconstruct_file.write("#CProcessor( \"01\",\"01b\",\"cat\",c_strProgCat,[] ),\n")

    sconstruct_file.write("# Generate MetaCyc enzyme abundances from BLAST hits\n")
    sconstruct_file.write("# Enable only if c_strInputMetaCyc is defined above\n")
    if args.metacyc_enz_abundance == 'true':
        sconstruct_file.write(" CProcessor( \"00\",\"11\",\"mtc\",c_strProgHits2Metacyc,[c_strFileMCC] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"00\",\"11\",\"mtc\",c_strProgHits2Metacyc,[c_strFileMCC] ),\n")

    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# hits -> metarep\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Optional: Generate a METAREP input file from BLAST hits\n")
    if args.metarep == 'true' :
        sconstruct_file.write(" CProcessor( \"00\",\"99\",\"mtr\",c_strProgHits2Metarep,[c_strFileGeneLs] ),\n")
    else:
        sconstruct_file.write("#  CProcessor( \"00\",\"99\",\"mtr\",c_strProgHits2Metarep,[c_strFileGeneLs] ),\n")

    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# enzymes -> pathways\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Generate KEGG pathway assignments from KOs\n")
    if args.kegg_pathway == 'true':
        sconstruct_file.write(" CProcessor( \"01\",\"02a\",\"mpt\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileKEGGC] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"01\",\"02a\",\"mpt\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileKEGGC] ),\n")

    sconstruct_file.write("# Generate KEGG module assignments from KOs\n")
    if args.kegg_module == 'true':
        sconstruct_file.write(" CProcessor( \"01\",\"02a\",\"mpm\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileModuleC] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"01\",\"02a\",\"mpm\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileModuleC] ),\n")

    sconstruct_file.write("# Generate MetaCyc pathway assignments from enzymes\n")
    if args.metacyc_pathway == 'true':
        sconstruct_file.write(" CProcessor( \"11\",\"02a\",\"mpt\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileMCPC] ),\n")
    else:
        sconstruct_file.write("#    CProcessor( \"11\",\"02a\",\"mpt\",c_strProgEnzymes2PathwaysMP,[c_strFileMP, c_strFileMCPC] ),\n")

    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# taxonomic provenance\n")
    sconstruct_file.write("#===============================================================================\n")
    if args.taxonomic_limitation == 'true':
        sconstruct_file.write(" CProcessor( \"02a\",\"02b\",\"cop\",c_strProgTaxlim,[c_strFileTaxPC, c_strFileKOC] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"02a\",\"02b\",\"cop\",c_strProgTaxlim,[c_strFileTaxPC, c_strFileKOC] ),\n")

    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# smoothing\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# Smoothing is disabled by default with the latest KEGG Module update\n")
    if args.wb_smoothing == 'true':
        sconstruct_file.write(" CProcessor( \"02b\",\"03a\",\"wbl\",c_strProgSmoothWB,[c_strFilePathwayC] ),\n")
    else:
        sconstruct_file.write(" CProcessor( \"02b\",\"03a\",\"wbl\",c_strProgSmoothWB,[c_strFilePathwayC] ),\n")
    sconstruct_file.write(" CProcessor( \"02b\",\"03a\",\"nul\",c_strProgCat,[] ),\n")

    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# gap filling\n")
    sconstruct_file.write("#===============================================================================\n")
    if args.gap_filling == 'true':
        sconstruct_file.write(" CProcessor( \"03a\",\"03b\",\"nve\",c_strProgGapfill,[c_strFilePathwayC] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"03a\",\"03b\",\"nve\",c_strProgGapfill,[c_strFilePathwayC] ),\n")

    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# COVERAGE\n")
    sconstruct_file.write("#===============================================================================\n")
    if args.coverage:
        sconstruct_file.write(" CProcessor( \"03b\",\"03c\",\"nve\",c_strProgPathCov,[c_strFilePathwayC, c_strFileModuleP] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"03b\",\"03c\",\"nve\",c_strProgPathCov,[c_strFilePathwayC, c_strFileModuleP] ),\n")
    if args.low_coverage_elimination == 'true':
        sconstruct_file.write(" CProcessor( \"03c\",\"04a\",\"xpe\",c_strProgPathCovXP,[c_strProgXipe] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"03c\",\"04a\",\"xpe\",c_strProgPathCovXP,[c_strProgXipe] ),\n")

    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# ABUNDANCE\n")
    sconstruct_file.write("#===============================================================================\n")
    if args.abundance_computation == 'true':
        sconstruct_file.write(" CProcessor( \"03b\",\"04b\",\"nve\",c_strProgPathAb,[c_strFilePathwayC, c_strFileModuleP] ),\n")
    else:
        sconstruct_file.write("# CProcessor( \"03b\",\"04b\",\"nve\",c_strProgPathAb,[c_strFilePathwayC, c_strFileModuleP] ),\n")

    sconstruct_file.write("]\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# A chain of piped finalizers runs on each file produced by the processing\n")
    sconstruct_file.write("# pipeline that is _not_ further processed; in other words, the coverage 04a and\n")
    sconstruct_file.write("# abundance 04b and 01b files.  Each finalizer consists of up to three parts:\n")
    sconstruct_file.write("#    An optional regular expression that must match filenames on which it is run\n")
    sconstruct_file.write("#    The processing script\n")
    sconstruct_file.write("#    A list of zero or more files provided on the command line to the processing script.\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("c_aastrFinalizers    = [\n")
    sconstruct_file.write(" [None,          c_strProgZero],\n")
    sconstruct_file.write(" [None,          c_strProgFilter,        [c_strFilePathwayC, c_strFileModuleP]],\n")
    sconstruct_file.write(" [r'0(1|(3b)|(4b))',  c_strProgNormalize],\n")
    sconstruct_file.write(" [None,          c_strProgEco],\n")
    #sconstruct_file.write("    [None,          c_strProgMetadata],\n")#,       [c_strInputMetadata]],\n")
    sconstruct_file.write("]\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("# A chain of piped exporters runs on each final file produced in the previous step.\n")
    sconstruct_file.write("# Each exporter consists of up to three parts:\n")
    sconstruct_file.write("#    An optional regular expression that must match filenames on which it is run\n")
    sconstruct_file.write("#    An array containing:\n")
    sconstruct_file.write("#        The processing script\n")
    sconstruct_file.write("#        An array of zero or more files provided on the command line to the processing script\n")
    sconstruct_file.write("#    A required tag for the file to differentiate it from other HUMAnN outputs\n")
    sconstruct_file.write("#===============================================================================\n")
    sconstruct_file.write("c_aastrExport        = [\n")
    sconstruct_file.write(" [r'04b.*mpt',   [[c_strProgGraphlanTree, [c_strFileGraphlan]]],     \"-graphlan_tree\"],\n")
    sconstruct_file.write(" [r'04b.*mpm',   [[c_strProgGraphlanTree, [c_strFileGraphlan]]],     \"-graphlan_tree\"],\n")
    sconstruct_file.write(" [r'04b.*mpt',   [[c_strProgGraphlanRings, [c_strFileGraphlan]]],    \"-graphlan_rings\"],\n")
    sconstruct_file.write(" [r'04b.*mpm',   [[c_strProgGraphlanRings, [c_strFileGraphlan]]],    \"-graphlan_rings\"],\n")
    sconstruct_file.write("]\n")
    sconstruct_file.write("\n")
    sconstruct_file.write("main( globals( ) )\n")

def formate_blast_output(input_report_filepath, 
    refseq_orga_id_corresp_filepath):
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


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--humann_dir', required=True)
    parser.add_argument('--cog_extracted_data', required=True)
    parser.add_argument('--ko_abundance', required=True)
    parser.add_argument('--kegg_pathway', required=True)
    parser.add_argument('--kegg_module', required=True)
    parser.add_argument('--metarep', required=True)
    parser.add_argument('--metacyc_enz_abundance', required=True)
    parser.add_argument('--metacyc_pathway', required=True)
    parser.add_argument('--taxonomic_limitation', required=True)
    parser.add_argument('--wb_smoothing', required=True)
    parser.add_argument('--gap_filling', required=True)
    parser.add_argument('--coverage', required=True)
    parser.add_argument('--low_coverage_elimination', required=True)
    parser.add_argument('--abundance_computation', required=True)
    args = parser.parse_args()
    print args

    formate_blast_output(args.input,args.cog_extracted_data)

    current_directory = os.getcwd()

    os.chdir(args.humann_dir)
    generate_humann_param_file('SConstruct', args, current_directory)
    os.system("scons")
    #os.system('ls data/')
    #print output_dir
    #os.system('ls ' + output_dir)
    os.chdir(current_directory)