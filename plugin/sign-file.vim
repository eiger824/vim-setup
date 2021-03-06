function! SignFile()
    " Parse the author from git's data
    let author = system("git config -z user.name")[:-2]
    let email = system("git config -z user.email")[:-2]
    let author = author." <".email.">"
    let filename = expand("%:t")
    call inputsave()
    let brief = input("Enter short description: ")
    call inputrestore()
    let lastmodified = system("date -R")[:-2]

    execute "normal! ggO"
    call feedkeys("<esc>")

    let open_pattern = GetFileExtension()
    let close_pattern = open_pattern
    if open_pattern == "//"
        let open_pattern = "/*"
        let close_pattern = "*/"
        call append(line('^')    , open_pattern)
        call append(line('^') + 1, " * Filename:      " . filename)
        call append(line('^') + 2, " *")
        call append(line('^') + 3, " * Author:        " . author)
        call append(line('^') + 4, " * Brief:         " . brief)
        call append(line('^') + 5, " * Last modified: " . lastmodified )
        call append(line('^') + 6, close_pattern)
    else
        call append(line('^')    , open_pattern)
        call append(line('^') + 1, open_pattern . " Filename:      " . filename)
        call append(line('^') + 2, open_pattern)
        call append(line('^') + 3, open_pattern . " Author:        " . author)
        call append(line('^') + 4, open_pattern . " Brief:         " . brief)
        call append(line('^') + 5, open_pattern . " Last modified: " . lastmodified )
        call append(line('^') + 6, open_pattern)
    endif
endfunction
