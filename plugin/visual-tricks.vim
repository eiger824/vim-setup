function! ToggleVisualWrap(type)
    let colInit  = 1
    let colEnd   = len(getline('.'))

    let posStart = getpos("'<")
    let posEnd   = getpos("'>")

    let colStart = posStart[2]
    let colStop = posEnd[2]

    echo "Pos start: " colStart ", pos End: " colStop
    echo "Pos init: " colInit ", pos End: " colEnd
    if colStop == colEnd
        execute "normal! dA" . a:type . "<esc>pA" . a:type . "<esc>"
    elseif colInit == colStart
        echo "This case"
"         execute "normal! di" . a:type . "<esc>pli" . a:type . "<esc>"
execute "normal! dd"
    endif
    " If selection is inside line (most normal case)
    if colStart > colInit && colEnd < colEnd
        execute "normal! di" . a:type . "<esc>pli" . a:type . "<esc>"
    endif
endfunction!
