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
    else
        echo "WARNING: individual word comment in same line not supported for current language, skipping..."
        return
    endif
    let close_pattern = join(reverse(split(open_pattern, '\zs')), '')
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    " TODO: investigate if a function already does this
    if line_start != line_end
        return
    endif
    let current_line_str = getline('.')
    let column_start -= 1
    let column_end -= 2
    let final_line_str = current_line_str
    let final_line = split(final_line_str, '\zs')
    let current_line = split(current_line_str, '\zs')
    let offset = 2
    call insert(final_line, open_pattern, column_start)
    call insert(final_line, close_pattern, column_end + offset)
    call setline(line('.'), join(final_line, ''))
endfun
