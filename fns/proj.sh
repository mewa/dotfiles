#!/bin/sh

function proj() {
    fuzzycd $PROJECTS_HOME $@
}

function fuzzycd() {
    local dir
    local path
    local base
    
    [[ -z $1 ]] && cd $HOME/projects && return 0

    base=$1
    shift
    while [[ -n $1 ]]; do
	path=$path$1*
	shift
    done
    dir=$(find $base -ipath "*$path" -type d | awk -F / '{ printf("%d\t%s\n", NF, $0); }' | sort -n | head -n1 | cut -f2)

    [[ -z $dir ]] && return -1
    
    echo Switching to $dir && cd $dir
}
