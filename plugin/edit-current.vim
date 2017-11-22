function! EditOnCurrentDir()
    let current = expand('%:p:h')
    call feedkeys(":edit " . current . "/")
endfunction
