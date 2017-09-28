#!/bin/sh

if [ ! -z $1 ]
then
    if [ $1 == "-f" ]
    then
	FORCE=f
    fi
fi

base=$(dirname $0)

ln -sv$FORCE $base/.bash* ~
ln -sv$FORCE $base/.profile ~
ln -sv$FORCE $base/.aliases ~
ln -sv$FORCE $base/.xmonad ~
ln -sv$FORCE $base/X11/.xinitrc ~
ln -sv$FORCE $base/X11/.Xresources ~
rm -r$FORCE ~/.emacs.d
ln -sv$FORCE $base/.emacs.d ~
ln -sv$FORCE $base/.gitconfig ~
