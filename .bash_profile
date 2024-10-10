# .bash_profile has higher priority, hence we need to load .profile manually
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ $- != *i* ]] && return

if [[ `uname` == Darwin ]]; then
    # bash completion on mac
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

    # homebrew setup
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# rbenv completion
command -v rbenv &>/dev/null && eval "$(rbenv init - bash)"

# nvm completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# interactive login shell, let's load .bashrc
source "$HOME/.bashrc"

# if it's a X11 environment - start it
command -v startx &> /dev/null && (pgrep 'startx' &> /dev/null || startx)

