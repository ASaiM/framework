Dereplicate sequences using prefix matching
===========================================

Dereplication is the identification of unique sequences so that only one copy of each sequence is reported. 

Here, `derep_prefix` command of `usearch` tool is used.

# Usage

```
path_to_usearch_bin -derep_prefix sequence_input_filepath \
    [-fastaout ...] \
    [-fastqout ...] \
    [-uc ...] \
    [-sizeout ...] \
    [-minuniquesize ...] \
    [-minseqlength ...] \
    [-relabel ...] \
    [-topn ...] 
```

# Parameters

The parameters of `derep_prefix` command are:

- `fastaout`: used to specify a FASTA file to contain the unique sequences. Sequences are sorted by decreasing cluster size.
- `fastqout`: used to specify a FASTQ file to contain the unique sequences. Sequences are sorted by decreasing cluster size.
- `uc` output file is supported, but not other standard output files.
- `sizeout`: used to specify that size annotations are added to the unique sequence labels. See cluster sizes.
- `minuniquesize`: used to set a minimum size for a cluster; unique sequences with smaller clusters are not included in the output file.
- `minseqlength`: used to specify a minimum sequence length. Using this option may significantly improve execution speed if there are very short sequences in the input which are not needed in the output.
- `relabel`: used to specify a string that is used to re-label the dereplicated sequences. An integer is appended to the label. E.g., -relabel D_ will generate sequences labels D_1, D_2 ... etc.
- `topn`: used to specify that only the largest N clusters will be written to the output file.