function! InitHeader()
    call inputsave()
    let symbol = input('Enter symbol to define: ')
    call inputrestore()

    call setline(line('.'), "#ifndef " . symbol)
    call setline(line('.') + 1, "#define " . symbol)
    call append(line('$'), "")
    call append(line('$'), "")
    call append(line('$'), "")
    call append(line('$'), "#endif /* " . symbol . " */")

    execute "normal! 3ji"

endfunction
