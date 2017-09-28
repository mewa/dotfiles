#!/bin/sh

function proj() {
    if [[ $1 == '-i' ]]; then
	local d=2
	shift
	while ! MAXDEPTH=$d fuzzycd $PROJECTS_HOME $@; do
	    d=$(($d+1))
	    echo -n \.
	done
    else
	fuzzycd $PROJECTS_HOME $@
    fi
}

function fuzzycd() {
    local dir
    local path
    local base
    local maxdepth
    
    [[ -z $1 ]] && cd $HOME/projects && return 0
    [[ -n $MAXDEPTH ]] && maxdepth="-maxdepth $MAXDEPTH"

    base=$1
    shift
    while [[ -n $1 ]]; do
	path=$path$1*
	shift
    done
    dir=$(find -L $base -ipath "*$path" -type d $maxdepth | awk -F / '{ printf("%d\t%s\n", NF, $0); }' | sort -n | head -n1 | cut -f2)

    [[ -z $dir ]] && return -1
    
    echo Switching to $dir && cd $dir
}
