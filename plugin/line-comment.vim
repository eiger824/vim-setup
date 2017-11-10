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

function! ToggleBlockLineComment(wholeline)
    let open_pattern = GetFileExtension()
    " Check if C/C++/Java/DTS file for /**/ type comments
    if open_pattern == "//"
        let open_pattern = "/*"
    endif
    let close_pattern = join(reverse(split(open_pattern, '\zs')), '')
    if a:wholeline == 0
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
    elseif a:wholeline == 1
        call VisualToggleBlockLineCommentRuntime()
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


fun! VisualToggleBlockLineCommentRuntime() range
    let open_pattern = GetFileExtension()
    " Check if C/C++/Java/DTS file for /**/ type comments
    if open_pattern == "//"
        let open_pattern = "/*"
    endif
    let close_pattern = join(reverse(split(open_pattern, '\zs')), '')
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    let selection = join(lines, "\n")
    " Commodity: remove last character
    let selection = selection[:-2]
    let result = substitute(getline('.'),
                \ selection,
                \ open_pattern . " " . selection . " " . close_pattern, "")
    " And finally, set the new line's value
    call setline(line('.'), result)
endfun
