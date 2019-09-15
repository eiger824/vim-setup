" Vundle related
set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Plugin list
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'joshdick/onedark.vim'
Plugin 'tpope/vim-surround'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'airblade/vim-gitgutter'
Plugin 'rafi/awesome-vim-colorschemes'
call vundle#end()

" Filetype related
filetype plugin indent on
filetype indent on

"""""""""""""""""""""""""""" LIGHTLINE Plugin """"""""""""""""""""""""
set laststatus=2

"""""""""""""""""""""""""""""""" NERDTree """"""""""""""""""""""""""""
let NERDTreeShowHidden=1

""""""""""""""""""""""""""""" vim color"""""""""""""""""""""""""""""""
colorscheme space-vim-dark
syntax on
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
    if (has("nvim"))
        " For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
        set termguicolors
    endif
endif

"""""""""""""""""""""""""""" GitGutter """""""""""""""""""""""""""""""
set updatetime=100


""""""""""""""""""""""""""" YouCompleteMe """"""""""""""""""""""""""""

" Use whitespaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set showcmd
set number
set cursorline

set wildmenu

set lazyredraw
set showmatch

set incsearch
set hlsearch

let mapleader=","

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=manual

"Source right autocomplete script depending on the language
let format = split(expand('%:t'), '\.')
if len(format) > 1
    let format = format[-1]
    if format ==# "c" || format ==# "h"
        let res = system("test -h ~/.vim/.ycm_extra_conf.py && rm -f ~/.vim/.ycm_extra_conf.py")
        let res = system("ln -s ~/.vim/.ycm_c_autocomp.py ~/.vim/.ycm_extra_conf.py")
    elseif format ==# "cc" || format ==# "cpp" || format ==# "tcc" || format ==# "tpp" || format == "hh" || format ==# "hpp"
        let res = system("test -h ~/.vim/.ycm_extra_conf.py && rm -f ~/.vim/.ycm_extra_conf.py")
        let res = system("ln -s ~/.vim/.ycm_c++_autocomp.py ~/.vim/.ycm_extra_conf.py")
    endif
endif
" And source our ycm script
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

if has("gui_running")
  if has("gui_gtk3")
      set guifont=Inconsolata\ 14
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

" KEYMAPS
" Insert mode keymaps
inoremap mF int main(int argc, char* argv[])<cr>{<cr><cr>return 0;<cr>}<cr><esc>3ki<tab>
inoremap iB #include <stdio.h>
inoremap jk <esc>ma0=$`a
inoremap ii <esc>2li
inoremap uu <esc>i
inoremap jj ()<esc>i
inoremap jJ ();<esc>hi
inoremap ( ()<esc>i
inoremap () ()<esc>i
inoremap hh []<esc>i
inoremap hH [];<esc>hi
inoremap [ []<esc>i
inoremap [] []<esc>i
inoremap kk <esc>A {<cr>}<esc>O
inoremap kK <esc>A {<cr>};<esc>O
inoremap { {}<esc>i
inoremap {} {}<esc>i
inoremap <leader>g {}<esc>i
inoremap <leader>G {};<esc>hi
inoremap ` ``<esc>i
inoremap `` ``<esc>i
inoremap "" ""<esc>i
inoremap cC ""<esc>i
inoremap '' ''<esc>i
inoremap <z <><esc>i
inoremap <> <><esc>i
inoremap nN \n
inoremap tT \t
inoremap <leader># #include 
inoremap <leader>D #define 
inoremap <leader>N <esc>:call InitHeader()<cr>
inoremap <leader><leader> <esc>A
inoremap <leader>c <esc>:call ToggleLineComment()<cr>A
inoremap <leader>C <esc>:call ToggleBlockLineComment(0)<cr>A
inoremap <leader>. <esc>:call ToggleBlockLineCommentRuntime()<cr>$hhi
inoremap <leader>b ${}<esc>i
inoremap <leader>n $()<esc>i

" Normal mode keymaps
nnoremap ; :Files<cr>
nnoremap <leader>o :NERDTreeToggle<cr>
nnoremap <leader><Right> :GitGutterNextHunk<cr>
nnoremap <leader><Left> :GitGutterPrevHunk<cr>
nnoremap <leader>F :YcmCompleter GoTo<cr>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap e $
nnoremap DD :1,$d<cr>
nnoremap <leader>j 30j
nnoremap <leader>k 30k
nnoremap <leader>l 30l
nnoremap <leader>h 30h
nnoremap z =$;
nnoremap <F5> :FSHere<cr>
nnoremap <leader>e :call EditOnCurrentDir()<cr>
nnoremap s :w<cr>
nnoremap se :wq<cr>
nnoremap qq :NERDTreeClose<cr>:q<cr>
nnoremap QQ :q!<cr>
nnoremap <leader>5 mzgg=G`z
nnoremap <leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <leader>a <esc>ggvG
nnoremap <F6> :call GetTranslationUnit(0)<cr>
nnoremap <F7> :call GetTranslationUnit(1)<cr>
nnoremap <C-C> :call BlockCommentInteractive()<cr>
nnoremap <C-U> :call BlockUncomment()<cr>
nnoremap <leader>c :call ToggleLineComment()<cr>
nnoremap <leader>C :call ToggleBlockLineComment(0)<cr>
nnoremap <leader>N :setlocal number!<cr>
nnoremap <leader>w :%s/\s/ /g<cr>:%s/\s\+$//g<cr>
nnoremap <leader>d :call Documentify()<cr>dd
nnoremap <space> :b#<cr>
nnoremap <leader><leader> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
nnoremap <C-w>h <C-w>s
nnoremap <C-n> <C-w>v
nnoremap <C-m> <C-w>s
nnoremap <C-l> <C-w><Right>
nnoremap <C-j> <C-w><Down>
nnoremap <C-k> <C-w><Up>
nnoremap <C-h> <C-w><Left>
nnoremap <leader>' ciw'<C-r>"'<esc>
nnoremap <leader><leader>' bdwhPlxx
nnoremap <leader>2 ciw"<C-r>""<esc>
nnoremap <leader><leader>2 bdwhPlxx
nnoremap <leader>7 ciw{<C-r>"}<esc>
nnoremap <leader><leader>7 bdwhPlxx
nnoremap <leader>8 ciw(<C-r>")<esc>
nnoremap <leader><leader>8 bdwhPlxx
nnoremap <leader>9 ciw[<C-r>"]<esc>
nnoremap <leader><leader>9 bdwhPlxx
nnoremap <leader>n :call SignFile()<cr>
nnoremap <leader><Tab> :call LineLengthCorrect()<cr>
nnoremap ga `a
nnoremap gb `b
nnoremap gc `c
nnoremap gd `d
nnoremap <leader>v :so $HOME/.vimrc<cr>
nnoremap <leader>b :buffers<cr>:buffer 

" Visual mode keymaps
vnoremap <C-C> :call VisualBlockComment()<cr>
vnoremap <leader>C :call VisualToggleBlockLineCommentRuntime()<cr>
vnoremap <leader>' di'<esc>pli'<esc>
vnoremap <leader><leader>' d2hPlxx
vnoremap <leader>2 di"<esc>pli"<esc>
vnoremap <leader><leader>2 d2hPlxx
vnoremap <leader>7 di{<esc>pli}<esc>
vnoremap <leader><leader>7 d2hPlxx
vnoremap <leader>8 di(<esc>pli)<esc>
vnoremap <leader><leader>8 d2hPlxx
vnoremap <leader>9 di[<esc>pli]<esc>
vnoremap <leader><leader>9 d2hPlxx
vnoremap <leader>f zf
vnoremap <leader>u zo
vnoremap <leader>k :call ContextBlock()<cr>
