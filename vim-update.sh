#!/bin/bash

# Super naive updater
# TODO: Add more options (interactive, verbose, etc)

source vim-common.src

usage()
{
    cat << EOF
USAGE: $(basename $0) [OPTIONS]

OPTIONS:
-h --help       Print this help and exit.
EOF
}

# Parse options
shortopts="h"
longopts="--long help"
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
    esac
    shift
done

# For most plugins
vim +PluginUpdate +qall
# For YCM
cd ${HOME}/.vim/bundle/YouCompleteMe
git pull --recurse-submodules
pushd third_party/ycmd
git pull
popd
./install.py --clang-completer

echo "Done."
