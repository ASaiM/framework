#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
from ftplib import FTP

###########
# Methods #
###########
def download_non_redundant_RefSeq_db(db_path):
	ftp = FTP("ftp.ncbi.nlm.nih.gov")
	ftp.login()
	ftp.cwd('/refseq/release/complete/')

	listing = []
	ftp.retrlines("LIST", listing.append)

	for file_description in listing:
		filename = file_description.split(' ')[-1]

		if filename.find('complete.nonredundant_protein') != -1 and filename.find('.faa') != -1:
			local_filename = os.path.join(db_path, filename)
			print "Download ", filename, '...'
			lf = open(local_filename, "wb")
			ftp.retrbinary("RETR " + filename, lf.write)
			lf.close()

			os.system('gunzip ' + local_filename)

	#os.system('cat ' + db_path + '*.faa > ' + db_path + 'complete.nonredundant_protein.fasta')
	#os.system('rm *.faa')


############################
# Public database download #
############################
if __name__ == '__main__':
	db_path = '/refseq/raw_data'
	if not os.path.exists(db_path):
		os.system('mkdir -p ' + db_path)

	download_non_redundant_RefSeq_db(db_path)



