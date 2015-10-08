#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

tool_dir=$1
galaxy_tool_dir=$2
current_dir=`pwd`

echo "Assemble paired end..."
create_tool_section_dir $galaxy_tool_dir/assemble_paired_end

## fastq-join
echo " FastQ-join..."
fastq_join_dir=assemble_paired_end/fastq_join 
create_copy_tool_dir $tool_dir/$fastq_join_dir $galaxy_tool_dir/$fastq_join_dir
cd $galaxy_tool_dir/$fastq_join_dir
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