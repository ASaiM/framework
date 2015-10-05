Galaxy wrapper for Blast
========================

# Arguments

Input query options

- `query <File_In>`: Input file name. Default = `-`
- `strand <String, both, minus, plus>`: Query strand(s) to search against 
database/subject. Default = `both`
- `query_gencode <Integer, values between: 1-6, 9-16, 21-25>`: Genetic code to 
use to translate query (see user manual for details). Default = `1`

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
query                             yes      yes      yes      yes       yes
strand                            yes      no       yes      no        yes
query_gencode                     no       no       yes      no        yes
-------------------------------------------------------------------------------

General search options

- `task <String>`: Task to execute. 
    - `blastn`: `blastn`, `blastn-short`, `dc-megablast`, `megablast`, `rmblastn`. 
    Default = `megablast`
    - `blastp`: `blastp`, `blastp-fast`, `blastp-short`. Default = `blastp`
    - `blastx`: `blastx`, `blastx-fast. Default = `blastx`
    - `tblastn`: `tblastn`, `tblastn-fast`. Default = `tblastn`
- `db <String>`: BLAST database name. Incompatible with `subject`, `subject_loc`
- `out <File_Out>`: Output file name. Default = `-`
- `evalue <Real>`: Expectation value (E) threshold for saving hits. Default = `10`
- `db_gencode <Integer, values between: 1-6, 9-16, 21-25>`: Genetic code to use 
to translate database/subjects (see user manual for details). Default = `1`
- `max_intron_length <Integer, >=0>`: Length of the largest intron allowed in a
 translated nucleotide sequence when linking multiple distinct alignments. 
Default = `0
- `comp_based_stats <String>`: Use composition-based statistics. Default = `2`
    - D or d: default (equivalent to 2 )
    - 0 or F or f: No composition-based statistics
    - 1: Composition-based statistics as in NAR 29:2994-3005, 2001
    - 2 or T or t : Composition-based score adjustment as in Bioinformatics, 
    21:902-911, 2005, conditioned on sequence properties
    - 3: Composition-based score adjustment as in Bioinformatics 21:902-911, 
    2005, unconditionally
- `use_index <Boolean>`: Use MegaBLAST database index. Default = `false`

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
task                              yes      yes      yes      yes       no
db                                yes      yes      yes      yes       yes
out                               yes      yes      yes      yes       yes
evalue                            yes      yes      yes      yes       yes
db_gencode                        no       no       no       yes       yes
max_intron_length                 no       no       yes      yes       yes
comp_based_stats                  no       yes      yes      yes       no
use_index                         yes      no       no       no        no 
-------------------------------------------------------------------------------

Formatting options

- `outfmt <String>`. Default = `0`
    - alignment view Options
        - 0 = pairwise,
        - 1 = query-anchored showing identities,
        - 2 = query-anchored no identities,
        - 3 = flat query-anchored, show identities,
        - 4 = flat query-anchored, no identities,
        - 5 = XML Blast output,
        - 6 = tabular,
        - 7 = tabular with comment lines,
        - 8 = Text ASN.1,
        - 9 = Binary ASN.1,
        - 10 = Comma-separated values,
        - 11 = BLAST archive format (ASN.1),
        - 12 = JSON Seqalign output,
        - 13 = JSON Blast output,
        - 14 = XML2 Blast output
    - Options 6, 7, and 10 can be additionally configured to produce a custom 
    format specified by space delimited format specifiers. The supported format 
    specifiers are:
        - `qseqid` means Query Seq-id
        - `qgi` means Query GI
        - `qacc` means Query accesion
        - `qaccver` means Query accesion.version
        - `qlen` means Query sequence length
        - `sseqid` means Subject Seq-id
        - `sallseqid` means All subject Seq-id(s), separated by a ';'
        - `sgi` means Subject GI
        - `sallgi` means All subject GIs
        - `sacc` means Subject accession
        - `saccver` means Subject accession.version
        - `sallacc` means All subject accessions
        - `slen` means Subject sequence length
        - `qstart` means Start of alignment in query
        - `qend` means End of alignment in query
        - `sstart` means Start of alignment in subject
        - `send` means End of alignment in subject
        - `qseq` means Aligned part of query sequence
        - `sseq` means Aligned part of subject sequence
        - `evalue` means Expect value
        - `bitscore` means Bit score
        - `score` means Raw score
        - `length` means Alignment length
        - `pident` means Percentage of identical matches
        - `nident` means Number of identical matches
        - `mismatch` means Number of mismatches
        - `positive` means Number of positive-scoring matches
        - `gapopen` means Number of gap openings
        - `gaps` means Total number of gaps
        - `ppos` means Percentage of positive-scoring matches
        - `frames` means Query and subject frames separated by a '/'
        - `qframe` means Query frame
        - `sframe` means Subject frame
        - `btop` means Blast traceback operations (BTOP)
        - `staxids` means unique Subject Taxonomy ID(s), separated by a ';' (in 
        numerical order)
        - `sscinames` means unique Subject Scientific Name(s), separated by a ';'
        - `scomnames` means unique Subject Common Name(s), separated by a ';'
        - `sblastnames` means unique Subject Blast Name(s), separated by a ';' (in
         alphabetical order)
        - `sskingdoms` means unique Subject Super Kingdom(s), separated by a ';' 
        (in alphabetical order)
        - `stitle` means Subject Title
        - `salltitles` means All Subject Title(s), separated by a '<>'
        - `sstrand` means Subject Strand
        - `qcovs` means Query Coverage Per Subject
        - `qcovhsp` means Query Coverage Per HSP
    - When not provided, the default value is: `qseqid sseqid pident length 
    mismatch gapopen qstart qend sstart send evalue bitscore`, which is 
    equivalent to the keyword `std`
- `show_gis`: Show NCBI GIs in deflines?
- `num_descriptions <Integer, >=0>`: Number of database sequences to show one-line
descriptions for. Not applicable for outfmt > 4. Default = `500`. Incompatible 
with `max_target_seqs`
- `num_alignments <Integer, >=0>`: Number of database sequences to show 
alignments for. Default = `250`. Incompatible with `max_target_seqs`
- `line_length <Integer, >=1>`: Line length for formatting alignments. Not 
applicable for outfmt > 4. Default = `60`
- `html`: Produce HTML output?

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
outfmt                            yes      yes      yes      yes       yes
show_gis                          yes      yes      yes      yes       yes
num_descriptions                  yes      yes      yes      yes       yes
num_alignments                    yes      yes      yes      yes       yes
line_length                       yes      yes      yes      yes       yes
html                              yes      yes      yes      yes       yes
-------------------------------------------------------------------------------

Query filtering options

- `dust <String>`: Filter query sequence with DUST (Format: "yes", 
"level window linker", or "no" to disable). Default = `20 64 1`
- `seg <String>`: Filter query sequence with SEG (Format: "yes", 
"window locut hicut", or "no" to disable). Default = `12 2.2 2.5
- `filtering_db <String>`: BLAST database containing filtering elements 
(i.e.: repeats)
- `window_masker_taxid <Integer>`: Enable WindowMasker filtering using a 
Taxonomic ID
- `window_masker_db <String>`: Enable WindowMasker filtering using this repeats 
database.
- `soft_masking <Boolean>`: Apply filtering locations as soft masks. Default = 
`true`
- `lcase_masking`: Use lower case filtering in query and subject sequence(s)?

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
dust                              yes      no       no       no        no 
seg                               no       yes      yes      yes       yes
filtering_db                      yes      no       no       no        no 
window_masker_taxid               yes      no       no       no        no 
window_masker_db                  yes      no       no       no        no 
soft_masking                      yes      yes      yes      yes       yes
lcase_masking                     yes      yes      yes      yes       yes
-------------------------------------------------------------------------------

Restrict search or results

- `gilist <String>`: Restrict search of database to list of GI's. Incompatible 
with `negative_gilist`, `seqidlist`, `remote`, `subject`, `subject_loc`
- `seqidlist <String>`: Restrict search of database to list of SeqId's.
Incompatible with  `gilist`, `negative_gilist`, `remote`, `subject`, `subject_loc`
- `negative_gilist <String>`: Restrict search of database to everything except 
the listed GIs. Incompatible with `gilist`, `seqidlist`, `remote`, `subject`, 
`subject_loc`
- `entrez_query <String>`: Restrict search with the given Entrez query. Requires
`remote`
- `db_soft_mask <String>`: Filtering algorithm ID to apply to the BLAST database 
as soft masking. Incompatible with `db_hard_mask`, `subject`, `subject_loc`
- `db_hard_mask <String>`: Filtering algorithm ID to apply to the BLAST database
 as hard masking. Incompatible with `db_soft_mask`, `subject`, `subject_loc`
- `perc_identity <Real, 0..100>`: Percent identity
- `qcov_hsp_perc <Real, 0..100>`: Percent query coverage per hsp
- `max_hsps <Integer, >=1>`: Set maximum number of HSPs per subject sequence to 
save for each query
- `culling_limit <Integer, >=0>`: If the query range of a hit is enveloped by 
that of at least this many higher-scoring hits, delete the hit. Incompatible 
with `best_hit_overhang`, `best_hit_score_edge`
- `best_hit_overhang <Real, (>0 and <0.5)>`: Best Hit algorithm overhang value 
(recommended value: 0.1). Incompatible with `culling_limit`
- `best_hit_score_edge <Real, (>0 and <0.5)>`: Best Hit algorithm score edge 
value (recommended value: 0.1). Incompatible with `culling_limit`
- `max_target_seqs <Integer, >=1>`: Maximum number of aligned sequences to keep.
Not applicable for outfmt <= 4. Default = `500`. Incompatible with 
`num_descriptions`, `num_alignments`

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
gilist                            yes      yes      yes      yes       yes
seqidlist                         yes      yes      yes      yes       yes
negative_gilist                   yes      yes      yes      yes       yes
entrez_query                      yes      yes      yes      yes       yes
db_soft_mask                      yes      yes      yes      yes       yes
db_hard_mask                      yes      yes      yes      yes       yes
perc_identity                     yes      no       no       no        no
qcov_hsp_perc                     yes      yes      yes      yes       yes
max_hsps                          yes      yes      yes      yes       yes
culling_limit                     yes      yes      yes      yes       yes
best_hit_overhang                 yes      yes      yes      yes       yes
best_hit_score_edge               yes      yes      yes      yes       yes
max_target_seqs                   yes      yes      yes      yes       yes
-------------------------------------------------------------------------------

Discontiguous MegaBLAST options

- `template_type <String, coding, coding_and_optimal, optimal>`: Discontiguous 
MegaBLAST template type. Requires `template_length`
- `template_length <Integer, Permissible values: "16" "18" "21">`: Discontiguous
MegaBLAST template length. Requires `template_type`

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
template_type                     yes      no       no       no        no  
template_length                   yes      no       no       no        no 
-------------------------------------------------------------------------------

Statistical options

- `dbsize <Int8>`: Effective length of the database
- `searchsp <Int8, >=0>`: Effective length of the search space
- `sum_stats <Boolean>`: Use sum statistics

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
dbsize                            yes      yes      yes      yes       yes
searchsp                          yes      yes      yes      yes       yes
sum_stats                         yes      yes      yes      yes       yes
-------------------------------------------------------------------------------

Search strategy options

- `import_search_strategy <File_In>`: Search strategy to use. Incompatible with
`export_search_strategy`
- `export_search_strategy <File_Out>`: File name to record the search strategy 
used. Incompatible with `import_search_strategy`

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
import_search_strategy            yes      yes      yes      yes       yes
export_search_strategy filename   yes      yes      yes      yes       yes
-------------------------------------------------------------------------------

Extension options

- `xdrop_ungap <Real>`: X-dropoff value (in bits) for ungapped extensions
- `xdrop_gap <Real>`: X-dropoff value (in bits) for preliminary gapped extensions
- `xdrop_gap_final <Real>`: X-dropoff value (in bits) for final gapped alignment
- `no_greedy`: Use non-greedy dynamic programming extension
- `min_raw_gapped_score <Integer>`: Minimum raw gapped score to keep an alignment
 in the preliminary gapped and traceback stages
- `ungapped`: Perform ungapped alignment only?
- `window_size <Integer, >=0>`: Multiple hits window size, use 0 to specify 
1-hit algorithm
- `off_diagonal_range <Integer, >=0>`: Number of off-diagonals to search for the
 2nd hit, use 0 to turn off. Default = `0`

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
xdrop_ungap                       yes      yes      yes      yes       yes
xdrop_gap                         yes      yes      yes      yes       no 
xdrop_gap_final                   yes      yes      yes      yes       no 
no_greedy                         yes      no       no       no        no 
min_raw_gapped_score              yes      no       no       no        no 
ungapped                          yes      yes      yes      yes       no
window_size                       yes      yes      yes      yes       yes
off_diagonal_range                yes      no       no       no        no 
-------------------------------------------------------------------------------

Miscellaneous options

- `parse_deflines`: Should the query and subject defline(s) be parsed?
- `num_threads <Integer, >=1>`: Number of threads (CPUs) to use in the BLAST 
search. Default = `1`. Incompatible with `remote`
- `remote`: Execute search remotely?. Incompatible with `gilist`, `seqidlist`, 
`negative_gilist`, `subject_loc`, `num_threads`
- `use_sw_tback`: Compute locally optimal Smith-Waterman alignments?

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
parse_deflines                    yes      yes      yes      yes       yes
num_threads                       yes      yes      yes      yes       yes
remote                            yes      yes      yes      yes       yes
use_sw_tback                      no       yes      yes      yes       no
-------------------------------------------------------------------------------

PSI-TBLASTN options

- `in_pssm <File_In>`: PSI-TBLASTN checkpoint file. Incompatible with `remote`, 
`query`, `query_loc`

Argument                          blastn   blastp   blastx   tblastn   tblastx
--------------------------------  -------  -------  -------  --------  --------
in_pssm                           no       no       no       yes       no
-------------------------------------------------------------------------------
