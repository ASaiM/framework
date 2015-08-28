#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
from ftplib import FTP
import inspect
import json_config_manipulation

###########
# Methods #
###########
def ftp_download(ftp, filename,dirpath):
    try:
        lf = open(dirpath + filename, "wb")
        ftp.retrbinary("RETR " + filename, lf.write)
        lf.close()

        #os.system('mv ' + filename + ' ' + dirpath + filename)
    except:
        raise ValueError(os.path.basename(__file__) + ' -- ' + inspect.stack()[1][3] + ": Error to download " + filename) 

def cog_download(cog_dirpath):
    #ftp = FTP("ftp.ncbi.nlm.nih.gov")
    ftp = FTP("130.14.250.7")
    ftp.login()
    ftp.cwd('/pub/COG/COG2014/data')

    ftp_download(ftp,"cog2003-2014.csv",cog_dirpath)
    ftp_download(ftp,"cognames2003-2014.tab",cog_dirpath)
    ftp_download(ftp,"fun2003-2014.tab",cog_dirpath)
    ftp_download(ftp,"prot2003-2014.fa.gz",cog_dirpath)
    ftp_download(ftp,"prot2003-2014.tab",cog_dirpath)

    os.system('gunzip ' + cog_dirpath + 'prot2003-2014.fa.gz')


#########################
# Download COG database #
#########################
if __name__ == '__main__':
    directory_information = json_config_manipulation.load_json_config_file('/src/global_information.json')
    raw_data_dirpath = json_config_manipulation.search_key_in_config_params(directory_information,"raw_data_dir")
    if not os.path.exists(raw_data_dirpath):
        os.system('mkdir -p ' + raw_data_dirpath)
    cog_download(raw_data_dirpath)
