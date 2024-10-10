# .bash_profile has higher priority, hence we need to load .profile manually
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ $- != *i* ]] && return


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# rbenv completion
command -v rbenv &>/dev/null && eval "$(rbenv init - bash)"

# interactive login shell, let's load .bashrc
source "$HOME/.bashrc"

# if it's a X11 environment - start it
command -v startx &> /dev/null && (pgrep 'startx' &> /dev/null || startx)

