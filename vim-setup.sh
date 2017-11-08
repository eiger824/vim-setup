#!/bin/bash

#
# The following script will configure Vim and tweak it to use
# custom keyboard mappings for a better experience
# 
# Author: Santiago Pagola

if [[ `basename $(pwd)` != "vim-setup" ]]
then
	echo "Run this script from root directory"
	exit 1
fi

# First find out which distro is being used

DISTRO=$(cat /etc/issue | cut -d" " -f1)
case ${DISTRO,,} in
	ubuntu)
		DISTRO=ubuntu
		PM=apt-get
		PMARGS="install -y"
		CLANG="libclang-dev"
		PY="python-dev python3-dev"
		BUILD_ESSENTIAL="build-essential"
		;;
	arch)
		DISTRO=arch
		PM=pacman
		PMARGS=-S
		CLANG="clang"
		PY="python"
		# Already included in the base package
		BUILD_ESSENTIAL=""
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
	# Last check: if it's NOT a symlink (before this script
	# came to life), just make a hard copy, not a symlink
	if [[ ! -h $HOME/.vimrc ]]
	then
		echo "Found, backing up"
		mv $HOME/.vimrc $HOME/.vimrc.old
	fi
else
	echo "Not found, creating new"
fi

test -h $HOME/.vimrc || ln -s $PWD/.vimrc $HOME/.vimrc

# Check that the file was successfully created
if [[ -h $HOME/.vimrc ]]
then
	echo "Success"
else
	echo "Something went wrong..."
fi

# Next: plugins
if [[ ! -d $HOME/.vim/plugin ]]
then
	mkdir -p $HOME/.vim/plugin
fi

for plugin in $(find plugin -type f)
do
	# Symlink each plugin instead of copying
	if [[ ! -h $HOME/.vim/$plugin ]]
	then
		echo "Symlinking $(basename $plugin)"
		ln -s $(pwd)/$plugin $HOME/.vim/$plugin
	fi
done


###########################################################
####################### 3rd party stuff ###################
###########################################################

###################### Onedark theme ######################
if [[ ! -d "$(pwd)/onedark.vim" ]]
then
	echo Onedark is missing, cloning ...
	git clone https://github.com/joshdick/onedark.vim.git
fi
if [[ ! -d "$HOME/.vim/colors" ]]
then
	echo "Creating $HOME/.vim/colors directory"
	mkdir $HOME/.vim/colors
fi
if [[ ! -h $HOME/.vim/colors/onedark.vim ]]
then
	echo "Symlinking colors/onedark.vim"
	ln -s $(pwd)/onedark.vim/colors/onedark.vim $HOME/.vim/colors/onedark.vim
fi

if [[ ! -d "$HOME/.vim/autoload" ]]
then
	echo "Creating $HOME/.vim/autoload directory"
	mkdir $HOME/.vim/autoload
fi
if [[ ! -h $HOME/.vim/autoload/onedark.vim ]]
then
	echo "Symlinking autoload/onedark.vim"
	ln -s $(pwd)/onedark.vim/autoload/onedark.vim $HOME/.vim/autoload/onedark.vim
fi
#############################################################

######################## FSwitch plugin #####################
if [[ ! -d "$(pwd)/vim-fswitch" ]]
then
	echo FSwitch is missing, cloning ...
	git clone https://github.com/derekwyatt/vim-fswitch.git
fi
if [[ ! -d "$HOME/.vim/doc" ]]
then
	echo "Creating $HOME/.vim/doc directory"
	mkdir $HOME/.vim/doc
fi
if [[ ! -h $HOME/.vim/doc/fswitch.txt ]]
then
	echo "Symlinking vim-fswitch/doc/fswitch.txt"
	ln -s $(pwd)/vim-fswitch/doc/fswitch.txt $HOME/.vim/doc/fswitch.txt
fi
if [[ ! -h $HOME/.vim/plugin/fswitch.vim ]]
then
	echo "Symlinking vim-fswitch/plugin/fswitch.vim"
	ln -s $(pwd)/vim-fswitch/plugin/fswitch.vim $HOME/.vim/plugin/fswitch.vim
fi
#############################################################


###################### YouCompleteMe ########################
if [[ ! -d "$HOME/.vim/bundle" ]]
then
	echo "Creating $HOME/.vim/bundle directory"
	mkdir $HOME/.vim/bundle
fi
# Clone the project directly in there
if [[ ! -d "$HOME/.vim/bundle/YouCompleteMe" ]]
then
	echo "YouCompleteMe is missing, cloning ..."
	mkdir $HOME/.vim/bundle/YouCompleteMe
	git clone https://github.com/Valloric/YouCompleteMe.git $HOME/.vim/bundle/YouCompleteMe
	echo "Installing necessary headers"
	`sudo $PM $PMARGS $BUILD_ESSENTIAL cmake $PY $CLANG`
	# Change directory there
	cd $HOME/.vim/bundle/YouCompleteMe
	echo -e "\t[YCM] Initializing project ..."
	git submodule update --init --recursive
	echo -e "\t[YCM] Building project ..."
	./install.py --clang-completer --system-libclang
	cd - &> /dev/null

	# YouCompleteMe source script
	echo "Copying YCM source script"
	cp .ycm_extra_conf.py $HOME/.vim
fi
#############################################################
