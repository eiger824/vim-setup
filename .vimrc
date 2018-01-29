set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set showcmd
set number
set cursorline

filetype indent on
filetype plugin indent on
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

"nnoremap A ^
nnoremap E $
" Append at end
inoremap <leader>E <esc>GA
nnoremap <leader>E <esc>GA
"nnoremap a ^
nnoremap e $

" Highlight last inserted text
nnoremap gV `[v`]

nnoremap DD :1,$d<cr>

" For the very lazy ass: mini-prototype of main() and classic includes
inoremap mF int main(int argc, char* argv[])<cr>{<cr><cr>return 0;<cr>}<cr><esc>3ki<tab>
inoremap iB #include <stdio.h>
inoremap hej #include <stdio.h><cr><cr>int main(int argc, char* argv[])<cr>{<cr><bs>printf("Hello world!\n");<cr>return 0;<cr>}

" Jump some lines
nnoremap <leader>j 30j
nnoremap <leader>k 30k
nnoremap <leader>l 30l
nnoremap <leader>h 30h

" Indent current line
nnoremap z =$;
" Escape mapping - super useful!
inoremap jk <esc>=$g;

" Escape next closing )]}
inoremap ii <esc>2li
inoremap uu <esc>i
" Parentheses
inoremap jj ()<esc>i
inoremap jJ ();<esc>hi
inoremap ( ()<esc>i
inoremap () ()<esc>i

" Square brackets
inoremap hh []<esc>i
inoremap hH [];<esc>hi
inoremap [ []<esc>i
inoremap [] []<esc>i

" Curly braces
inoremap <leader>g {}<esc>i
inoremap <leader>G {};<esc>hi
inoremap { {}<esc>i
inoremap {} {}<esc>i

" Backtick
inoremap ` ``<esc>i
inoremap `` ``<esc>i

" Add context in newline
inoremap kk <esc>A<cr>{<cr>}<esc>O

" Quotation marks
inoremap "" ""<esc>i
inoremap cC ""<esc>i
inoremap '' ''<esc>i
" close < and >
inoremap <z <><esc>i
inoremap <> <><esc>i

inoremap nN \n
inoremap tT \t

" Some language-related tricks: C++
inoremap cout cout <<  << endl;<esc>8hi
inoremap cerr cerr <<  << endl;<esc>8hi
" C/C++
inoremap <leader># #include 
inoremap <leader>D #define
inoremap <leader>N <esc>:call InitHeader()<cr>

" The very best: eE will move the cursor to the end
" iif both previous and next chars are non-space
inoremap <leader><leader> <esc>A

" File-Switch (FS) mappings
nnoremap <F5> :FSHere<cr>
nnoremap <C-o> :call EditOnCurrentDir()<cr>

nnoremap s :w<cr>
nnoremap se :wq<cr>
nnoremap qq :q<cr>
nnoremap QQ :q!<cr>
nnoremap <leader>5 mzgg=G`z

nnoremap <leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <leader>a <esc>ggvG

"Source right autocomplete script depending on the language
let format = split(expand('%:t'), '\.')
if len(format) > 1
    let format = format[-1]
    if format ==# "c"
        let res = system("test -h ~/.vim/.ycm_extra_conf.py && rm -f ~/.vim/.ycm_extra_conf.py")
        let res = system("ln -s ~/.vim/.ycm_c_autocomp.py ~/.vim/.ycm_extra_conf.py")
    else
        let res = system("test -h ~/.vim/.ycm_extra_conf.py && rm -f ~/.vim/.ycm_extra_conf.py")
        let res = system("ln -s ~/.vim/.ycm_c++_autocomp.py ~/.vim/.ycm_extra_conf.py")
    endif
endif
" And source our ycm script
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

nnoremap <F6> :call GetTranslationUnit(0)<cr>
nnoremap <F7> :call GetTranslationUnit(1)<cr>

" Comments: add new block comment
inoremap <C-A> /*<cr><cr>/<cr><esc>kkA 
inoremap <C-C> <esc>:call BlockCommentInteractive()<cr>i
nnoremap <C-C> :call BlockCommentInteractive()<cr>
vnoremap <C-C> :call VisualBlockComment()<cr>
inoremap <C-U> <esc>:call BlockUncomment()<cr>i
nnoremap <C-U> :call BlockUncomment()<cr>

" Comment current line
inoremap <leader>c <esc>:call ToggleLineComment()<cr>A
nnoremap <leader>c :call ToggleLineComment()<cr>
inoremap <leader>C <esc>:call ToggleBlockLineComment(0)<cr>A

vnoremap <leader>C :call VisualToggleBlockLineCommentRuntime()<cr>

nnoremap <leader>C :call ToggleBlockLineComment(0)<cr>
inoremap <leader>. <esc>:call ToggleBlockLineCommentRuntime()<cr>$hhi

" Turn on/off line mode
nnoremap <leader>N :setlocal number!<cr>
" Remove trailing whitespaces
nnoremap <leader>w :call RemoveTrailingWhitespaces()<cr>

" Explore word under cursor
nnoremap <leader>f :call ExploreSymbolUnderCursor()<cr>
nnoremap <leader>e :call EnhancedSymbolSearch()<cr>
nnoremap <leader>d :call Documentify()<cr>dd

" Switch to previous buffer
nnoremap <space> :b#<cr>

" Makefile variables
inoremap <leader>b ${}<esc>i
" New bash command
inoremap <leader>n $()<esc>i

" Exec command
nnoremap <leader>m :w<cr>:call CommandExec()<cr>
" Autohighlight remap
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

nnoremap <leader>n :call SignFile()<cr>
nnoremap <leader><Tab> :call LineLengthCorrect()<cr>

" Backspace fix
inoremap ^? <bs>
