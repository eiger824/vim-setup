fun! ContextBlock() range
    let lineStart = getpos("'<")[1]
    let lineEnd = getpos("'>")[1]
    call append(lineStart, "{")
    call append(lineEnd+1, "}")
endfun!
