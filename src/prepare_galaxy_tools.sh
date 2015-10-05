#!/bin/bash

galaxy_tool_dir=$1/tools/
current_dir=`pwd`
db_dir=/db/

## prinseq
echo "PRINSEQ..."
prinseq_dir=$galaxy_tool_dir/quality_control/prinseq
mkdir -p $prinseq_dir/src
curl -L -s http://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz | tar -C $prinseq_dir/src/ --strip-components=1 -xz

## fastq-join
echo "FastQ-join..."
cd $galaxy_tool_dir/paired_end_assembly/fastq_join 
svn checkout http://ea-utils.googlecode.com/svn/trunk/
if [ ! -e trunk/clipper/fastq_join ]; then
    cd trunk/clipper
    make >> $current_dir/tmp/fastq_join_make 2> $current_dir/tmp/fastq_join_make_errors
    if grep "Error" $current_dir/tmp/fastq_join_make > /dev/null ; then
        echo "Error with make for FastQ Join"
        exit
    fi
fi
cd $current_dir

## infernal
if ! which cmsearch > /dev/null; then
    echo "Infernal..."
    echo -e "install infernal on machine (needed to use reago)? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        infernal_dir=$galaxy_tool_dir/rna_manipulation/infernal
        cd $infernal_dir
        tar xzf infernal-1.1.1.tar.gz
        cd infernal-1.1.1

        ./configure >> $current_dir/tmp/infernal_configure
        if grep "Error" $current_dir/tmp/infernal_configure > /dev/null ; then
            echo "Error with configure for Infernal"
            exit
        fi

        make >> $current_dir/tmp/infernal_make
        if grep "Error" $current_dir/tmp/infernal_make > /dev/null ; then
            echo "Error with make for Infernal"
            exit
        fi 

        sudo make install >> $current_dir/tmp/infernal_make_install
        if grep "Error" $current_dir/tmp/infernal_make_install > /dev/null ; then
            echo "Error with make install for Infernal"
            exit
        fi
        cd $current_dir
    fi
fi

## blast
echo "Blast..."
cd $galaxy_tool_dir/similarity_search/blast/
if [ ! -d "ncbi-blast-2.2.31+-x64-linux/" ]; then
    mkdir ncbi-blast-2.2.31+-x64-linux
    curl -L -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-x64-linux.tar.gz | tar -C ncbi-blast-2.2.31+-x64-linux --strip-components=1 -xz
fi
if [ ! -d "ncbi-blast-2.2.31+-universal-macosx/" ]; then
    mkdir ncbi-blast-2.2.31+-universal-macosx
    curl -L -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-universal-macosx.tar.gz | tar -C ncbi-blast-2.2.31+-universal-macosx --strip-components=1 -xz
fi
cd $current_dir

## metaphlan 2
echo "Metaphlan 2..."
cd $galaxy_tool_dir/non_rRNA_taxonomic_assignation/metaphlan2/metaphlan2/
git-hg pull
#if [ ! -d "metaphlan2/" ]; then
#    echo "  cloning"
#    hg clone https://bitbucket.org/biobakery/metaphlan2 
#else
#    echo "  updating"
#    cd "metaphlan2/"
#    hg pull
#    cd ../
#fi
cd $current_dir

## humann 2
#humann2_dir=$galaxy_dir/metabolic_analysis/humann2
#cd $humann2_dir 
#hg clone https://bitbucket.org/biobakery/humann2 
#cd humann2 
#python setup.py install 
#cd $current_dir

## humann 
echo "HUMAnN..."
cd $galaxy_tool_dir/metabolic_analysis/humann
if [ ! -d "humann/" ]; then
    echo "  cloning"
    hg clone https://bitbucket.org/biobakery/humann
    cd humann/
    mkdir original_data/
    cp data/* original_data/
    cp SConstruct original_data/
    cp $current_dir/data/db/metacyc/meta.tar.gz data/  
    
    scons >> $current_dir/tmp/humann_initial_scons 
    cd data/MinPath/glpk-4.6/
    autoconf >> $current_dir/tmp/humann_glpk_autoconf
    if grep "Error" $current_dir/tmp/humann_autoconf > /dev/null ; then
        echo "Error with autoconf for glpk in humann"
        exit
    fi

    ./configure >> $current_dir/tmp/humann_glpk_configure
    if grep "Error" $current_dir/tmp/humann_glpk_configure > /dev/null ; then
        echo "Error with configure for glpk in humann"
        exit
    fi

    make clean >> $current_dir/tmp/humann_glpk_make_clean
    if grep "Error" $current_dir/tmp/humann_make_clean > /dev/null ; then
        echo "Error with make clean for glpk in humann"
        exit
    fi

    make >> $current_dir/tmp/humann_glpk_make
    if grep "Error" $current_dir/tmp/humann_glpk_make > /dev/null ; then
        echo "Error with make for glpk in humann"
        exit
    fi    
else
    echo "  updating"
    cd humann/
    hg pull
fi
cd $current_dir

## retrieve cog, extract info and formate for use with humann
echo "COG downloading, extracting and formating..."
cog_dir=data/db/cog/
if [ ! -e $cog_dir/raw_data/prot2003-2014.fa ]; then
    python $cog_dir/src/download_database.py \
        --raw_data_dir $cog_dir/raw_data/
fi
if [ ! -e $cog_dir/extracted_data/genels.gz ]; then
    python $cog_dir/src/extract_cog_data.py \
        --raw_data_dir $cog_dir/raw_data/ \
        --extracted_data_dir $cog_dir/extracted_data/
fi
if [ ! -e $cog_dir/humann_formated_data/map_kegg.txt ]; then
    python $cog_dir/src/formate_database_for_humann.py \
        --raw_data_dir $cog_dir/raw_data/ \
        --extracted_data_dir $cog_dir/extracted_data/ \
        --humann_formated_data_dir $cog_dir/humann_formated_data/ \
        --humann_dir $humann_dir/humann/
fi
if [ ! -d $humann_dir/humann/cog_data/ ]; then
    mkdir $humann_dir/humann/cog_data/
fi

cp $cog_dir/humann_formated_data/* $humann_dir/humann/cog_data/
cp $cog_dir/extracted_data/refseq_orga_id_correspondance $humann_dir/humann/cog_data/




