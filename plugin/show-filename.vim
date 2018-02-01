function! ShowCurrentFile()
    let current = expand('%:p')
    echo "Current file:\t" . current 
endfunction
