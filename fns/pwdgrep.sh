#!/bin/sh

# Searches recursively for files in TARGET directory
# (current working directory by default) and searches
# for occurrences of PATTERNS
function pwdgrep() {
    local target
    local string

    if [[ "$#" -eq 0 ]]; then
        echo Usage: pwdgrep [TARGET] PATTERN...
    elif [[ "$#" -ge 2 ]]; then
        target=$1
        shift
    else
        target=.
    fi

    string=$1
    local files=$(find $target -type f ! -path '*/.git/*')
    while [[ ! -z "$string" ]]; do
        echo "$files" | xargs -I% grep -Hn --color=always "$string" "%"
        shift
        string=$1
    done
}
