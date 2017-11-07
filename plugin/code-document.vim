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
	call AddField(current_line, "Function: " . name)
	let current_line += 1

	let desc = Prompt("Description: ")
	call AddField(current_line, "Brief: " . desc)
	let current_line += 1

	

	call feedkeys("<cr>")

endfunction
