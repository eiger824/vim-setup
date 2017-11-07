function! ExploreSymbolUnderCursor()
	let current_word = expand("<cword>")
	let current_line = line('.')
	let current_file = expand("%:p")
	echo "Current file: " . current_file
	let topDir = GetRootDir()

	let matches = systemlist("grep -wnr " . current_word . " " . topDir . "/*")

	let n = len(matches)

	if n == 1
		let match_split = split(matches[0], ':')
		let file = match_split[0]
		let line = match_split[1]
		if file == current_file
			echo 'Only match found in this file, skipping ...'
		else
			echo 'About to open file ' . file . ' at line ' . line
			execute ":edit " . file
		endif
	else
		let i = 0
		while i < n
			let match_split = split(matches[i], ':')
			if len(match_split) == 3
				let file = match_split[0]
				let line = match_split[1]
				let pattern = match_split[2]
				echo string(i) . "\t" . '"' . pattern . '"' . " at file: " . file . " (line " . string(line) . ")"
			endif
			let i+= 1
		endwhile
		let opt = -1
		while opt < 0 || opt >= n 
			call inputsave()
			let opt = input('Select option: ')
			call inputrestore()
		endwhile
		let match_split = split(matches[opt], ':')
		let file = match_split[0]
		let line = match_split[1]
		" Last check: if file AND line are same
		if file == current_file && line == current_line
			echo "\nCurrent result selected, skipping ..."
		else
			execute ":edit " . file
		endif
	endif
endfunction
