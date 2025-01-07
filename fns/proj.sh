#!/bin/sh

function proj() {
    if [[ $1 == '-i' ]]; then
	shift
    fi

    fuzzycd $@
}

function get_path_pattern {
    local path

    path="$1"
    shift

    while [[ -n $1 ]]; do
	path="$path $1"
	shift
    done

    echo "$path"
}

function fuzzycd() {
    local path
    local base
    local bfs
    local dir

    if [[ $1 == "-base" ]]; then
        echo base is base
        base="${2:-.}"
        shift
        shift
    else
        base="$PROJECTS_HOME"
    fi

    path=$(get_path_pattern "$@")
    bfs="bfs -type d -s -L -exclude -name .git -exclude -name node_modules"
    dir=$(cd "$base"; $bfs | fzf -e -i -q "$path" --no-sort --scheme=path --height ~30%)

    echo Switching to "$base/$dir" && cd "$base/$dir"
}
