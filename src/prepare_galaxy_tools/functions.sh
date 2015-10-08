#!/bin/bash

function create_tool_section_dir {
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

function create_copy_tool_dir {
    if [ ! -d $2 ]; then
        mkdir -p $2
    fi
    cp -r $1/* $2
}