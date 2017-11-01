#!/bin/bash

#
# The following script will configure Vim and tweak it to use
# custom keyboard mappings for a better experience
# 
# Author: Santiago Pagola

# First find out which distro is being used
function which_distro
{
    local DISTRO=$(cat /etc/issue | cut -d" " -f1)
    case ${DISTRO,,} in
	ubuntu)
	    return 0
	    ;;
	arch)
	    return 1
	    ;;
	*)
	    return 2
	    ;;
    esac
}

which_distro
case $? in
    0)
	DISTRO=ubuntu
	PM=apt-get
	PMARGS=install -y
	;;
    1)
	DISTRO=arch
	PM=pacman
	PMARGS=-S
	;;
    2)
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

cat << EOF > $HOME/.vimrc
set tabstop=4
set softtabstop=4
"set expandtab

set showcmd
set number
set cursorline

filetype indent on
filetype plugin on
set wildmenu

set lazyredraw
set showmatch

set incsearch
set hlsearch

let mapleader=","

nnoremap <leader><space> :nohlsearch<CR>

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

" nnoremap A ^
nnoremap E $
" nnoremap a ^
nnoremap e $
nnoremap s <nop>


" Alias for esc
inoremap jk <esc>

" Add curly braces and place cursor inbetween indented
inoremap kk <esc>A<cr>{<cr>}<cr><esc>kko<backspace>

" Add open and close parentheses and place cursor inbetween
inoremap jj ()<esc>i
" Same as above but adding a ; at the end
inoremap jjj ();<esc>hi

" C - newline
inoremap nn \n
" C - tab
inoremap tt \t


" Add citation marks and put cursor inbetween
inoremap cc ""<esc>i

nnoremap s :w<cr>
nnoremap se :wq<cr>
nnoremap qq :q<cr>
nnoremap QQ :q!<cr>

execute pathogen#infect()

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

"Apply onedark coloring
colorscheme onedark 
syntax on
EOF

# Check that the file was successfully created
test -f $HOME/.vimrc && echo "Success!"
test -f $HOME || echo "Failed to write to $HOME/.vimrc"

# Next: plugins

