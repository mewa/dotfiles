#!/bin/sh

function proj() {
    local dirs
    local dir
    local len
    local tmp
    local base
    local name
    
    [[ -z $1 ]] && cd $HOME/projects && return 0

    base=$1
    shift
    name=$1
    shift

    dirs=$(find $base -mindepth 1 -maxdepth 1 -type d -iname "*$name*")
    
    for idir in $dirs; do
	[[ -n $1 ]] && proj $idir $@
	if [[ -z $1 ]]; then
	    tmp=$(echo $idir | tr '/' '\n' | wc -l)
	    if [[ $tmp -lt $len ]] || [[ -z $dir ]]; then
	    	len=$tmp
	    	dir=$idir
	    fi
	fi
    done

    [[ -n $1 ]] && return
    [[ -z $dir ]] && return -1
    
    echo Switching to $dir | grep -i "" --color=auto
    cd $dir
}
