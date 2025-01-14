#!/bin/bash
_complete() {
    results=$(set -eo pipefail; aws secretsmanager list-secrets | jq -r --arg pattern "${COMP_WORDS[1]}" '.SecretList | map(.Name | select(test($pattern // true))) | sort | .[]')
    COMPREPLY=($(compgen -W "${results}"))
}

complete -F _complete secrets
