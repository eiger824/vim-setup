#!/bin/bash

#
# The following script will configure Vim and tweak it to use
# custom keyboard mappings for a better experience
#
# Author: Santiago Pagola

source vim-common.src

usage()
{
    cat << EOF
USAGE: $(basename $0) [OPTIONS]

OPTIONS:
-h --help               Print this help and exit.
-c --check-privileges   Only check whether the current user has root privileges to install packages
-o --only-own-plugins   Only own-defined plugins, i.e., no third party stuff is installed (i.e.)
                        no color schemes, no autocorrect.
-s --show               Show only information about current distro and packages to install
                        This is the default mode, i.e., by default, everything is installed.
-t --third-party        Install third party plugins as well.
EOF
}

# Parse options
checkonly=0
showonly=0
thirdparty=1
shortopts="hcost"
longopts="--long help --long check-privileges --long only-own-plugins --long show --long third-party"
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
        -c|--check-privileges)
            checkonly=1
            ;;
        -o|--only-own-plugins)
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

if [ ${checkonly} -eq 1 ]; then
    if check_if_su_allowed; then
        echo "User \`$USER' is allowed to install system packages."
    else
        echo "User \`$USER' is NOT allowed to install system packages."
    fi
    exit 0
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
    if check_if_su_allowed; then
        echo "The following dependencies will be installed :$ ${pm} ${pm_args} ${pkgs} vim"
    else
        echo "No external dependencies will be installed since user \`$(whoami)' is not allowed to run the package manager on this system"
    fi
    exit 0
fi

if check_if_su_allowed; then
    # Find out if vim installed. Usually, vim should be in /usr/bin/vim
    echo "Installing dependencies first"
    sudo ${pm} ${pm_args} ${pkgs}

    if [[ ! -f /usr/bin/vim ]]; then
        echo "Going to install vim!"
        sudo ${pm} ${pm_args} vim
    fi

else
    echo "User is NOT allowed to download packages. Proceed with care."
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

# Before moving on to the 3rd party stuff, we need to temporarily
# disable the colorscheme onedark since it will be installed
# by Vundle the first time:
sed -i -e 's/^colorscheme/"colorscheme/g' ${HOME}/.vimrc

###########################################################
####################### 3rd party stuff ###################
###########################################################

########################## VUNDLE ###########################
# Set up VUNDLE
if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    mkdir -p ~/.vim/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    # Install YCM
    echo -n "Install plugins now (it may take a long time)? [Y/n]: "
    read ans
    case $ans in
        [yY]|[yY][eE][sS]|"")
            vim +PluginInstall +qall
            # And restore the right colorscheme
            sed -i -e 's/^"colorscheme/colorscheme/g' ${HOME}/.vimrc
            ;;
        *)
            echo "Skipping install. You can install plugins with :PluginInstall from inside vim."
            ;;

    esac
else
    echo "Installing new plugins"
    vim +PluginInstall +qall
fi
#############################################################

###################### YouCompleteMe ########################
# Set up VUNDLE
echo "Download completed. Building now!"
pushd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer
popd

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

