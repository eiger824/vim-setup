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
