# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent)
fi

# fix for 'mighty' Java in tiling window managers
export _JAVA_AWT_WM_NONREPARENTING=1

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$HOME/.cargo/bin:$PATH"

command -v mpd && [ ! -s "~/.config/mpd/pid" ] && mpd &

export GOPATH="$(echo ~/projects/go)"
export PATH="$PATH:$GOPATH/bin"

source $HOME/.aliases

pgrep emacs 1>/dev/null || emacs --daemon &
