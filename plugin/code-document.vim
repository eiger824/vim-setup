function Prompt(str)
	call inputsave()
	let ans = input(a:str)
	call inputrestore()
	return ans
endfunction

function AddField(linr, str)
	call append(a:linr, a:str)
	execute ":w"
	execute ":edit " . expand("%:p")
endfunction


function! Documentify()
	let current_line = line('.') - 1

	call AddField(current_line, "/*")
	let current_line += 1

	call AddField(current_line, "*/")

	let name = Prompt("Function name: ")
	call AddField(current_line, " * Function:\t" . name)
	let current_line += 1

	let desc = Prompt("Description: ")
	call AddField(current_line, " * Brief:\t" . desc)
	let current_line += 1

	let any = Prompt("Any params? [Y]n: ")
	if empty(any) || any == "Y" || any == "y"
		let n = Prompt("Enter nr. params: ")
		let current = 0

		while current < n
			let param_name = Prompt(string(current + 1) . "/" . string(n) . ' Param name: ')
			let param_desc = Prompt(string(current + 1) . "/" . string(n) . ' Param description: ')
			call AddField(current_line, " * @param " . param_name . ":\t" . param_desc)
			let current += 1
			let current_line += 1
		endwhile
	endif

	let returns = Prompt("Return value(s)?: ")
	call AddField(current_line, " * Returns:\t" . returns)

	call feedkeys("<cr>")

endfunction
