function Prompt(str)
	call inputsave()
	let ans = input(a:str)
	call inputrestore()
	return ans
endfunction

function AddField(linr, str)
	call append(a:linr, a:str)
" 	execute ":w"
" 	execute ":edit " . expand("%:p")
endfunction


function! Documentify()

    let format = GetFileExtension()
    let separator = ""

	let current_line = line('.') - 1
    let line_containing_fname = getline(current_line + 2)
    let name = system("echo \"".line_containing_fname."\" | cut -d\"(\" -f1 | sed -e \"s,\\s\\+,\\n,g\" | sed -e \"/^\\s*$/d\" | tail -1")
    let name = name[0:-2]

    if format == "//"
        call AddField(current_line, "/*")
        let current_line += 1
        let separator=" *"
    elseif format == "#"
        let separator="#"
    endif

    if format == "//"
        call AddField(current_line, "*/")
    endif

    call AddField(current_line, separator . " Function:            " . name)
	let current_line += 1

	let desc = Prompt("Description: ")
    call AddField(current_line, separator . " Brief:               " . desc)
	let current_line += 1

	let any = Prompt("Any params? [Y]n: ")
	if empty(any) || any == "Y" || any == "y"
		let n = Prompt("Enter nr. params: ")
		let current = 0

		while current < n
			let param_name = Prompt(string(current + 1) . "/" . string(n) . ' Param name: ')
			let param_desc = Prompt(string(current + 1) . "/" . string(n) . ' Param description: ')
            call AddField(current_line, separator . " @param " . param_name . ":     " . param_desc)
			let current += 1
			let current_line += 1
		endwhile
	endif

	let returns = Prompt("Return value(s)?: ")
    call AddField(current_line, separator . " Returns:             " . returns)

	call feedkeys("<cr>")

endfunction
