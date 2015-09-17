#!/bin/bash

makeblastdb -in "test-data/db/db.fasta" -dbtype "prot"

#for i in {0..12}
for i in 6 7 10
do
    echo "Blast -outfmt $i"

    blast_dir="test-data/blast/"
    report_blast_dir="$blast_dir/extraction_reports"
    output_blast_dir="$blast_dir/extraction_outputs"

    blastx -db "test-data/db/db.fasta" \
        -query "test-data/data/query.fasta" \
        -out "$blast_dir/blast_outputs/outfmt_$i.txt" \
        -outfmt $i

    echo "    Simple extraction..."
    extraction_dir="simple_extraction"
    python extract_similarity_search_report.py \
        --input "$blast_dir/blast_outputs/outfmt_$i.txt" \
        --tool "blast" \
        --format "$i" \
        --use_default_specifiers 'default' \
        --to_extract "{qseqid,sseqid,pident,evalue}" \
        --report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"
    python test-data/src/compare_generated_files.py \
        --exp_report "$report_blast_dir/$extraction_dir/expected.txt" \
        --obs_report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --exp_output "$output_blast_dir/$extraction_dir/expected.txt" \
        --obs_output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"

    echo "    Simple constraint on pident..."
    extraction_dir="simple_constraint_on_pident"
    python extract_similarity_search_report.py \
        --input "$blast_dir/blast_outputs/outfmt_$i.txt" \
        --tool "blast" \
        --format "$i" \
        --use_default_specifiers 'default' \
        --to_extract "{qseqid,sseqid,pident,evalue}" \
        --constraint "pident: greater: 40" \
        --report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"
    python test-data/src/compare_generated_files.py \
        --exp_report "$report_blast_dir/$extraction_dir/expected.txt" \
        --obs_report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --exp_output "$output_blast_dir/$extraction_dir/expected.txt" \
        --obs_output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"

    echo "    Double constraint on pident..."
    extraction_dir="double_constraint_on_pident"
    python extract_similarity_search_report.py \
        --input "$blast_dir/blast_outputs/outfmt_$i.txt" \
        --tool "blast" \
        --format "$i" \
        --use_default_specifiers 'default' \
        --to_extract "{qseqid,sseqid,pident,evalue}" \
        --constraint "pident: greater: 40" \
        --constraint "pident: lower: 60" \
        --report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"
    python test-data/src/compare_generated_files.py \
        --exp_report "$report_blast_dir/$extraction_dir/expected.txt" \
        --obs_report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --exp_output "$output_blast_dir/$extraction_dir/expected.txt" \
        --obs_output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"

    echo "    List constraint on qseqid..."
    extraction_dir="list_constraint_on_qseqid"
    python extract_similarity_search_report.py \
        --input "$blast_dir/blast_outputs/outfmt_$i.txt" \
        --tool "blast" \
        --format "$i" \
        --use_default_specifiers 'default' \
        --to_extract "{qseqid,sseqid,pident,evalue}" \
        --constraint "pident: greater: 40" \
        --constraint "pident: lower: 60" \
        --constraint "qseqid: not_in: $blast_dir/qseqid_not_in_list.txt" \
        --report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"
    python test-data/src/compare_generated_files.py \
        --exp_report "$report_blast_dir/$extraction_dir/expected.txt" \
        --obs_report "$report_blast_dir/$extraction_dir/outfmt_$i.txt" \
        --exp_output "$output_blast_dir/$extraction_dir/expected.txt" \
        --obs_output "$output_blast_dir/$extraction_dir/outfmt_$i.txt"
done

