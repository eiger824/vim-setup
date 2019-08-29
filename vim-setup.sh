#!/bin/bash

#
# The following script will configure Vim and tweak it to use
# custom keyboard mappings for a better experience
#
# Author: Santiago Pagola

usage()
{
    cat << EOF
USAGE: $(basename $0) [OPTIONS]

OPTIONS:
-h --help           Print this help and exit.
-o --only-plugins   Only plugins, i.e., no third party stuff is installed (i.e.) no
                    color schemes, no autocorrect.
-s --show           Show only information about current distro and packages to install
                    This is the default mode, i.e., by default, everything is installed.
-t --third-party    Install third party plugins as well.
EOF
}

err()
{
    echo "$@" >&2
}

die()
{
    err "$@"
    exit 1
}

get_host()
{
    local name
    local fname
    name="$@"
    fname="/etc/issue"

    if grep -i -E '(ubuntu)' ${fname} &> /dev/null; then
        echo -n "ubuntu"
    elif grep -i -E '(elementary)' ${fname} &> /dev/null; then
        echo -n "elementary"
    elif grep -i -E '(mint)' ${fname} &> /dev/null; then
        echo -n "mint"
    elif grep -i -E '(debian)' ${fname} &> /dev/null; then
        echo -n "debian"
    elif grep -i arch ${fname} &> /dev/null; then
        echo -n "arch"
    else
        # TODO: add more options. What about *BSD?
        echo -n "fedora"
    fi
}

check_git_user_set()
{
	local name
	local email
	if [ ! -f ~/.gitconfig ]; then
		echo -n "Enter your GIT user name: "
		read name
		echo -n "Enter your GIT user e-mail: "
		read email
		git config --global user.name $name
		git config --global user.email $email
	fi
}

# Parse options
showonly=0
thirdparty=1
shortopts="host"
longopts="--long help --long only-plugins --long show --long third-party"
options=$(getopt -o ${shortopts} ${longopts} -- "$@")
[ $? -eq 0 ] ||
{
    usage
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -o|--only-plugins)
            thirdparty=0
            ;;
        -s|--show)
            showonly=1
            ;;
        -t|--third-party)
            thirdparty=1
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

if [[ `basename $(pwd)` != "vim-setup" ]]
then
    echo "Run this script from root directory"
    exit 1
fi

check_git_user_set

# First find out which distro is being used
HOST=$(get_host)
case ${HOST,,} in
    ubuntu|elementary|mint|debian)
        distro=debian
        pm=apt
        pm_args="install -y"
        pkgs="python-dev python3-dev build-essential cmake"
        ;;
    arch)
        distro=arch
        pm=pacman
        pm_args=-S
        # build-essential already included in the base package
        pkgs="python cmake"
        ;;
    *)
        distro=fedora
        pm=yum
        pm_args=install
        pkgs="python python3 cmake"
        ;;
esac

echo "Current distro: ${distro} (${HOST})"

# Just print some info if -s was provided
if [ ${showonly} -eq 1 ]; then
    cat << EOF
The following dependencies will be installed:

$ ${pm} ${pm_args} ${pkgs} vim
EOF
    exit 0
fi

# Find out if vim installed. Usually, vim should be in /usr/bin/vim
echo "Installing dependencies first"
sudo ${pm} ${pm_args} ${pkgs}

if [[ ! -f /usr/bin/vim ]]; then
    echo "Going to install vim!"
    sudo ${pm} ${pm_args} vim
fi

# Next, copy our favorite .vimrc. Don't just override if existing .vimrc
# is found at home, first back it up
echo "Looking for existent .vimrc in $HOME"
if [[ -f $HOME/.vimrc ]]; then
    # Last check: if it's NOT a symlink (before this script
    # came to life), just make a hard copy, not a symlink
    if [[ ! -h $HOME/.vimrc ]]; then
        echo "Found, backing up"
        mv $HOME/.vimrc $HOME/.vimrc.old
    fi
else
    echo "Not found, creating new"
fi

test -h $HOME/.vimrc || ln -s $PWD/.vimrc $HOME/.vimrc

# Check that the file was successfully created
if [[ -h $HOME/.vimrc ]]; then
    echo "Success"
else
    err "Something went wrong..."
fi

# Next: plugins
if [[ ! -d $HOME/.vim/plugin ]]; then
    mkdir -p $HOME/.vim/plugin
fi

for plugin in $(find plugin -type f); do
    # Symlink each plugin instead of copying
    if [[ ! -h $HOME/.vim/$plugin ]]; then
        echo "Symlinking $(basename $plugin)"
        ln -s $(pwd)/$plugin $HOME/.vim/$plugin
    fi
done

# Keep on if third-party was set
if [ ${thirdparty} -eq 0 ]; then
    echo -e "\nDone"
    exit 0
fi
###########################################################
####################### 3rd party stuff ###################
###########################################################

###################### Onedark theme ######################
if [[ ! -d "$(pwd)/onedark.vim" ]]; then
    echo Onedark is missing, cloning ...
    git clone https://github.com/joshdick/onedark.vim.git
fi
if [[ ! -d "$HOME/.vim/colors" ]]; then
    echo "Creating $HOME/.vim/colors directory"
    mkdir $HOME/.vim/colors
fi
if [[ ! -f $HOME/.vim/colors/onedark.vim ]]; then
    echo "Symlinking colors/onedark.vim"
    ln -s $(pwd)/onedark.vim/colors/onedark.vim $HOME/.vim/colors/onedark.vim
fi

if [[ ! -d "$HOME/.vim/autoload" ]]; then
    echo "Creating $HOME/.vim/autoload directory"
    mkdir $HOME/.vim/autoload
fi
if [[ ! -h $HOME/.vim/autoload/onedark.vim ]]; then
    echo "Symlinking autoload/onedark.vim"
    ln -s $(pwd)/files/onedark-custom-colors.vim $HOME/.vim/autoload/onedark.vim
fi
#############################################################

######################## FSwitch plugin #####################
if [[ ! -d "$(pwd)/vim-fswitch" ]]; then
    echo FSwitch is missing, cloning ...
    git clone https://github.com/derekwyatt/vim-fswitch.git
    echo "Applying custom patch ..."
    cd vim-fswitch
    git am ../patches/0001-cc-h-fswitch.patch
    cd ..
fi
if [[ ! -d "$HOME/.vim/doc" ]]; then
    echo "Creating $HOME/.vim/doc directory"
    mkdir $HOME/.vim/doc
fi
if [[ ! -h $HOME/.vim/doc/fswitch.txt ]]; then
    echo "Symlinking vim-fswitch/doc/fswitch.txt"
    ln -s $(pwd)/vim-fswitch/doc/fswitch.txt $HOME/.vim/doc/fswitch.txt
fi
if [[ ! -h $HOME/.vim/plugin/fswitch.vim ]]; then
    echo "Symlinking vim-fswitch/plugin/fswitch.vim"
    ln -s $(pwd)/vim-fswitch/plugin/fswitch.vim $HOME/.vim/plugin/fswitch.vim
fi
#############################################################

####################### vim-surround ########################
if [[ ! -d "$(pwd)/vim-surround" ]]; then
    echo "vim-surround is missing, cloning ..."
    git clone https://github.com/tpope/vim-surround.git
fi
if [[ ! -h $HOME/.vim/doc/surround.txt ]]; then
    echo "Symlinking vim-surround documentation file"
    ln -s $(pwd)/vim-surround/doc/surround.txt $HOME/.vim/doc/surround.txt
fi
if [[ ! -h $HOME/.vim/plugin/surround.vim ]]; then
    echo "Symlinking vim-surround/plugin/surround.vim"
    ln -s $(pwd)/vim-surround/plugin/surround.vim $HOME/.vim/plugin/surround.vim
fi
#############################################################

###################### YouCompleteMe ########################
# Set up VUNDLE
test -d ~/.vim/bundle/Vundle.vim ||
{
    mkdir -p ~/.vim/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    # Install YCM
    echo -n "Install plugins now (it may take a long time)? [Y/n]: "
    read ans
    case $ans in
        [yY]|[yY][eE][sS]|"")
            vim +PluginInstall +qall
            echo "Download completed. Building now!"
            pushd ~/.vim/bundle/YouCompleteMe
            ./install.py --clang-completer
            popd
            ;;
        *)
            echo "Skipping install. You can install plugins with :PluginInstall from inside vim."
            ;;

    esac
}
# YouCompleteMe source scripts
if [[ ! -f $HOME/.vim/.ycm_c_autocomp.py ]]; then
    echo "Copying YCM C autocompletion source script"
    cp .ycm_c_autocomp.py $HOME/.vim
fi
if [[ ! -f $HOME/.vim/.ycm_c++_autocomp.py ]]; then
    echo "Copying YCM C++ autocompletion source script"
    cp .ycm_c++_autocomp.py $HOME/.vim
fi
#############################################################
ret=$?
echo -e "\nDone."
exit ${ret}

