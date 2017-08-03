#!/usr/bin/sh

if [ ! -z $1 ]
then
    if [ $1 == "-f" ]
    then
	FORCE=f
    fi
fi

ln -sv$FORCE $(pwd)/.bash* ~
ln -sv$FORCE $(pwd)/.profile ~
ln -sv$FORCE $(pwd)/.aliases ~
ln -sv$FORCE $(pwd)/.xmonad ~
ln -sv$FORCE $(pwd)/X11/.xinitrc ~
ln -sv$FORCE $(pwd)/X11/.Xresources ~
ln -sv$FORCE $(pwd)/.emacs.d ~
ln -sv$FORCE $(pwd)/.gitconfig ~
