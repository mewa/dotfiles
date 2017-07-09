# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
PATH="$HOME/.local/bin:$PATH"

alias sudo='sudo '
alias ll='ls -l'
alias la='ll -a'
alias e='emacs'
