dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

xrdb ~/.Xresources

setxkbmap -option "ctrl:nocaps" &
feh --no-fehbg --randomize --bg-scale /usr/share/backgrounds/*
redshift &>/dev/null &

compton -b
exec xmonad
