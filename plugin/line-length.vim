" Filename:			line-length.vim
"
" Author:			Santiago Pagola
" Brief:			Given a (possibly) long string, this function will return a list
"                   with at most maxLineLength characters per entry
" Last modified:	tor 28 dec 2017 10:50:14 CET
"

function! LineLength(inputStr, maxAllowedLineLength)

    let maxLineLength = a:maxAllowedLineLength

    let splitList = split(a:inputStr, ' ')
    let returnList = []

    let index = 0
    let currentLength = 0
    let currentSentence = ""

    while index < len(splitList)
        let currentSentence = currentSentence . splitList[index] . " "
        let currentLength = len(currentSentence)
        if currentLength == maxLineLength
            call add(returnList, currentSentence)
            " Reset the sentence
            let currentSentence = ""
        elseif currentLength > maxLineLength
            " Cut out the last word and put it into currentSentence
            let tmp = split(currentSentence, ' ')
            let currentSentence = tmp[-1] . ' '
            call add(returnList, join(tmp[0:-2], ' '))
        endif
        let index += 1
    endwhile
    " Last check: add what remains in currentSentence
    call add (returnList, currentSentence)
    let a = 0
    while a < len(returnList)
        let a+=1
    endwhile
    return returnList
endfunction

function! LineLengthCorrect()

    call inputsave()
    let maxLength = input('Enter maximum line length (default:80): ')
    call inputrestore()

    " Set 80 by default
    if empty(maxLength)
        let maxLength = 80
    endif

    let currentLine = line('^')
    let endLine = line('$')
    while currentLine < endLine
        let splitSentence = LineLength(getline(currentLine), maxLength)
        " Just do the shortening if needed
        if len(splitSentence) > 1
            let index = 1
            " First, set current line to the first entry of the list
            call setline(currentLine, splitSentence[index - 1])

            while index < len(splitSentence)
                " Then, append the remaining entries after the current line
                call append(currentLine + index - 1, splitSentence[index])
                let index += 1
            endwhile
            " Add up the new end line
            let endLine += len(splitSentence)
        endif
        " Add up the line counter
        let currentLine += len(splitSentence) 
    endwhile
endfunction
