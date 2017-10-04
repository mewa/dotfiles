# .bash_profile has higher priority, hence we need to load .profile manually
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ $- != *i* ]] && return

# interactive login shell, let's load .bashrc
source "$HOME/.bashrc"

# if it's a X11 environment - start it
command -v startx &> /dev/null && (pgrep 'startx' &> /dev/null || startx)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
