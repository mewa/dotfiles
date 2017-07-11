dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

xrdb ~/.Xresources

setxkbmap -option "ctrl:nocaps" &
feh --randomize --bg-scale /usr/share/backgrounds/*

compton -b
exec xmonad
