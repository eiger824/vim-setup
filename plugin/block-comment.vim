function! BlockComment(line1, line2)
    call append(a:line1 - 1, "/*")
    call append(a:line2 + 1, "*/")
endfunction

function! BlockCommentInteractive()
    "Get first line from line number line1
    let init = 1
    let end = line('$')
    let correct = 0
    while correct == 0
        call inputsave()
        let line1 = input('Starting line?: ')
        call inputrestore()
        if line1 > 0 && line1 < end
            let correct = 1
        endif
    endwhile

    let correct = 0
    while correct == 0
        call inputsave()
        let line2 = input('End line?: ')
        call inputrestore()
        if line2 > 0 && line2 < end && line1 <= line2
            let correct = 1
        endif
    endwhile
    call BlockComment(line1, line2)
endfunction

function! BlockUncomment()
    let init_line = line('^')
    let last_line = line('$')
    " Get current line number
    let current_line = line('.')
    let line = current_line
    " Loop upwards looking for the /* sequence
    " Search() will return the line number
    let position = search('\/\*', 'b', 'W')
    " Search now downwards for the */ sequence
    let position2 = search('\*\/', 'W')
    " Last check: if there is a whole file comment
    " and the first line is actually the start of the
    " comment. It happens that if no /* or */ are found,
    " that the initial and end lines are returned from
    " the search() command
    if position == init_line && position2 == last_line
        let found = match(getline(init_line), "/*")
        echo "found: " . string(found)
        if found == 0
            exe position . 'd'
            let updated_position2 = position2 - 1
            exe updated_position2 . 'd'
        endif
    else
        "  		if position == position2
        "  			echo 'Not found'
        "  		else
        exe position . 'd'
        let updated_position2 = position2 - 1
        exe updated_position2 . 'd'
        "  		endif
    endif
endfunction

fun! VisualBlockComment() range
    let line_start = getpos("'<")[1]
    let line_end = getpos("'>")[1]
    call BlockComment(line_start, line_end) 
endfun
