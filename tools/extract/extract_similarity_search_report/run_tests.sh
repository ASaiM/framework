#!/bin/bash

makeblastdb -in "test-data/db/db.fasta" -dbtype "prot"

#for i in {0..12}
for i in {6}
do
    blastx -db "test-data/db/db.fasta" \
        -query "test-data/data/query.fasta" \
        -out "test-data/blast/blast_outputs/outfmt_$i.txt" \
        -outfmt ${i}
    python extract_similarity_search_report.py \
        --input "test-data/blast/blast_outputs/outfmt_$i.txt" \
        --tool "blast" \
        --format "$i" \
        --use_default_specifiers 'default' \
        --to_extract "{qseqid,sseqid,pident,evalue}" \
        --constraint "pident: greater: 40" \
        --report "test-data/blast/extraction_reports/outfmt_$i.txt" \
        --output "test-data/blast/extraction_outputs/outfmt_$i.txt"
done

