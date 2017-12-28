function! SignFile()
    call inputsave()
    let author = input("Enter author(s): ")
    call inputrestore()
    let filename = expand("%")
    call inputsave()
    let brief = input("Enter short description: ")
    call inputrestore()
    let lastmodified = system("date")[:-2]

    execute "normal! O"
    call feedkeys("<esc>")

    let open_pattern = GetFileExtension()
    let close_pattern = open_pattern
    if open_pattern == "//"
        let open_pattern = "/*"
        let close_pattern = "*/"
        call append(line('^')    , open_pattern)
        call append(line('^') + 1, " * Filename:\t\t" . filename)
        call append(line('^') + 2, "")
        call append(line('^') + 3, " * Author:\t\t\t" . author)
        call append(line('^') + 4, " * Brief:\t\t\t" . brief)
        call append(line('^') + 5, " * Last modified:\t" . lastmodified )
        call append(line('^') + 6, close_pattern)
    else
        call append(line('^')    , open_pattern)
        call append(line('^') + 1, open_pattern . " Filename:\t\t\t" . filename)
        call append(line('^') + 2, open_pattern)
        call append(line('^') + 3, open_pattern . " Author:\t\t\t" . author)
        call append(line('^') + 4, open_pattern . " Brief:\t\t\t" . brief)
        call append(line('^') + 5, open_pattern . " Last modified:\t" . lastmodified )
        call append(line('^') + 6, open_pattern)
    endif
endfunction
