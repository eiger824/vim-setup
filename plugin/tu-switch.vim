" Function to look for translation-unit pairs (i.e. header/source files)
" at common locations
" Author: Santiago Pagola

nnoremap asdf GetTranslationUnit()
function! GetTranslationUnit()
  let file2Search = getline(".")
  echo 'Will search for:' file2Search
  
endfunction
