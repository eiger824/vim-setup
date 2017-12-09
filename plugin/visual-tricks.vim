function! IsWordToggled(word, line, openToken, closeToken)
    "Return 0/1 if word is surrounded by marks
    let splitSentence = split(a:line, '\zs')
    echo "Sentence was: " splitSentence
    let index = 0
    while index < len(splitSentence)
        let current = join(splitSentence[index:index+len(a:word)-1], '')
        echo "Current word: " . current . ", current index = "index
        if current ==# a:word
            " Check if word not at the beginning
            if index > 0 && a:line[index-1] ==# a:openToken
                        \ && a:line[index+1] ==# a:closeToken
                return 0
            else
                return 1
            endif
        endif
        let index += 1
    endwhile
    echo "Word not found, returning 1 ..."
    return 1
endfunction

function! ToggleCurlyBraces()
    let currentWord = expand("<cword>")
    let res = IsWordToggled(currentWord, getline("."), "{", "}")
    echo "Current word is: "res
    call setline(line("."), substitute(getline("."), currentWord, '{' . currentWord . '}', ""))
endfunction

function! ToggleParentheses()
    let currentWord = expand("<cword>")
    call setline(line("."), substitute(getline("."), expand("<cword>"), '(' . currentWord . ')', ""))
endfunction

function! ToggleSquareBrackets()
    let currentWord = expand("<cword>")
    call setline(line("."), substitute(getline("."), expand("<cword>"), '[' . currentWord . ']', ""))
endfunction

function! ToggleStringMarks()
    let currentWord = expand("<cword>")
    call setline(line("."), substitute(getline("."), expand("<cword>"), '"' . currentWord . '"', ""))
endfunction
