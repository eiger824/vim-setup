function! SanitizeString(str)
    let string = substitute(a:str, '^\s\+', '', '')
    let string = substitute(string, '\s\+$', '', '')
    return string
endfunction

function! GetRelativePath(filename, topdir)
	let split_filename = split(a:filename, '/')
	let split_topdir = split(a:topdir, '/')
	return join(split_filename[len(split_topdir):], '/')
endfunction

function! ExploreSymbolUnderCursor()
	let current_word = expand("<cword>")
	let current_line = line('.')
	let current_file = expand("%:p")
	let topDir = GetRootDir()
	let homeDir = system("echo -n $HOME")
    if topDir ==# homeDir
		echo 'Searching in ' . homeDir . ', this may take forever. Skipping search'
		return
	endif
    let simpleName = split(topDir, '/')[-1]
    echo 'Searching for "' . current_word . '" in ' . simpleName 
	let matches = systemlist("grep -wnr " . current_word . " " . topDir . "/* | sed -e 's/\:\s\+/\:/g'")
	let n = len(matches)
    echo 'Done! ' n ' matches found'
	if n == 1
		let match_split = split(matches[0], ':')
		let file = match_split[0]
		let line = match_split[1]
		if file == current_file
			echo 'Only match found in this file, skipping ...'
		else
			echo 'About to open file ' . GetRelativePath(file,topDir)
						\ . ' at line ' . line
            execute ":edit +" . line . " " . file
		endif
	else
		let i = 0
		while i < n
			let match_split = split(matches[i], ':')
			if len(match_split) >= 3
                let file = SanitizeString(match_split[0])
                let line = SanitizeString(match_split[1])
                let pattern = SanitizeString(match_split[2])

                echo i "   \"" . pattern . "\""
                echo "     File: " . GetRelativePath(file,topDir) . " (line " line ")\n\n"
			endif
            let i+= 1
		endwhile
		let opt = -1
        while opt < 0 || opt >= n || empty(opt)
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
            execute ":edit +" . line . " " . file
		endif
	endif
endfunction
