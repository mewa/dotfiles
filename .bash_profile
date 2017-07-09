[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent)
fi

pgrep 'startx' || startx
