#!/bin/bash

#
# The following script will configure Vim and tweak it to use
# custom keyboard mappings for a better experience
# 
# Author: Santiago Pagola

# First find out which distro is being used

DISTRO=$(cat /etc/issue | cut -d" " -f1)
case ${DISTRO,,} in
    ubuntu)
	DISTRO=ubuntu
	PM=apt-get
	PMARGS=install -y
	;;
    arch)
        DISTRO=arch
	PM=pacman
	PMARGS=-S
	;;
    *)
        DISTRO=other
	PM=yum
	PMARGS=install
	;;
esac

echo "Current distro: $DISTRO"


# Find out if vim installed. Usually, vim should be in /usr/bin/vim
if [[ -f /usr/bin/vim ]]
then
    echo "Vim found, skipping download..."
else
    echo "Going to install vim!"
    `sudo $PM $PMARGS vim`
fi

# Next, copy our favorite .vimrc. Don't just override if existing .vimrc
# is found at home, first back it up
echo "Looking for existent .vimrc in $HOME"
if [[ -f $HOME/.vimrc ]]
then
    echo "Found, backing up"
    mv $HOME/.vimrc $HOME/.vimrc.bkup
else
    echo "Not found, creating new"
fi

test -h $HOME/.vimrc || ln -s $PWD/.vimrc $HOME/.vimrc

# Check that the file was successfully created
test -h $HOME/.vimrc && echo "Success!" && exit 0

echo "Something went wrong..."

# Next: plugins

