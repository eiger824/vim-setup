function! GetFileExtension()
    let current_filename = expand("%")
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Check for file format, since comment mark will depend
    " on that
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""
    let format = split(current_filename, '\.')[-1]
    if format == "c" || format == "h" ||
                \ format == "cpp" || format == "hpp" || format == "cc" || format == "cxx" ||
                \ format == "tpp" ||
                \ format == "java" ||
                \ format == "dts"
        return "//"
    elseif format == "sh" || format == "bash"
        return "#"
    elseif format == "vim" || format == "vimrc"
        return '"'
    elseif format == "bashrc" || format == "bash_aliases"
        return "#"
    endif
endfunction

function! ToggleLineComment()
    " Get current line
    let current_filename = expand("%")
    let line = getline('.')
    let pattern = GetFileExtension()
    " Check if line starts with pattern: recommended format
    let comment = substitute(line, '^\s*' . fnameescape(pattern) . '\s*', "", "")

    if comment == line  "  No comment was found  "
        call setline(line('.'), pattern . " " . line)
    else  "  Comment was found  "
        call setline(line('.'), comment)
        " Indent current line
        execute "normal! =$"
    endif
endfunction

function! ToggleBlockLineComment()
    let open_pattern = GetFileExtension()
    " Check if C/C++/Java/DTS file for /**/ type comments
    if open_pattern == "//"
        let open_pattern = "/*"
    endif
    let close_pattern = join(reverse(split(open_pattern, '\zs')), '')
    " Get current line
    let line = getline('.')
    let comment1 = substitute(line, fnameescape(open_pattern) . '\s*', "", "")
    let comment2 = substitute(comment1, '\s*' . fnameescape(close_pattern), "", "")
    if line == comment2  " No comment was found  "
        call setline(line('.'), open_pattern . " " . line . " ". close_pattern)
    else  " Comment was found "
        call setline(line('.'), comment2)
        execute "normal! =$"
    endif
endfunction


function! ToggleBlockLineCommentRuntime()
    let open_pattern = GetFileExtension()
    if open_pattern == "//"
        let open_pattern = "/*"
    endif
    let close_pattern = join(reverse(split(open_pattern, '\zs')), '')
    let line = getline('.')
    let comment1 = substitute(line, fnameescape(open_pattern) . '\s*', "", "")
    let comment2 = substitute(comment1, '\s*' . fnameescape(close_pattern), "", "")
    if line == comment2  " No comment was found  "
        call setline(line('.'), getline('.') . " " . open_pattern . "  " . close_pattern)
    else
        call setline(line('.'), comment2)
    endif
endfunction
