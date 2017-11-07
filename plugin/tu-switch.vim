" Function to look for translation-unit pairs (i.e. header/source files)
" at common locations
" Author: Santiago Pagola

function GetRootDir()
	" Start the file seach from the top .git parent-directory,
	" assumming the directory hierarchy is version-controlled
	let rootDir2 = finddir(".git", ".;")
	let rootDir1 = fnamemodify(rootDir2, ':p:h')
	let rootDir_esc = fnameescape(rootDir1)

	let dirSplit = split(rootDir_esc, '/')
	" If for some reason the last element is .git, remove it
	if dirSplit[-1] == ".git"
		" Get rid of last element
		let fullPath = dirSplit[:-2]
		return "/" . join(fullPath, '/')
	else
		" Then simply return the input directory
		return rootDir_esc
	endif
endfunction

function! GetTranslationUnit(place)
	let include_line = getline(".")
	let sys_parts = split(include_line, '<')

	" If this is a local include -> search for "
	if sys_parts[0] == include_line
		let loc_parts = split(include_line, '"')
		let headerName = split(loc_parts[1], '"')[0]
	else
		let headerName = split(sys_parts[1], '>')[0]
		let searchDir = '/usr/include'
	endif

	" Last check: if relative paths are found
	let simpleHeaderName = split(headerName, '/')[-1]
	
	let rootDir = GetRootDir()

	if empty(rootDir)
		echo 'WARNING: No .git directories were found, skipping search'
	else
		if sys_parts[0] == include_line
			let paths = systemlist("find " . rootDir . " -name " . simpleHeaderName)
		else
			let paths = systemlist("find " . searchDir . " -name " . simpleHeaderName)
		endif
		if empty(paths)
			echo 'WARNING: File not found (' . headerName . ')'
		else
			" Prompt the user which result to choose
			echo 'Found the following matches to "' . headerName . '", select index to open:'
			if len(paths) > 1
				let index = 0
				while index <= len(paths) - 1
					echo string(index) . "\t" . paths[index]
					let index = index + 1
				endwhile
				" Prompt the user which result to choose
				while 1
					call inputsave()
					let fnr = input('Which result?: ')
					call inputrestore()
					if fnr >= 0 && fnr < len(paths)
						break
					endif
				endwhile
				let full_path = fnameescape(paths[fnr])
				if a:place == 0
					execute "rightbelow vsplit " . full_path
				else
					execute ":edit " . full_path
				endif
			else
				" Just open that file
				echo 'Found: ' . paths[0]
				let full_path = fnameescape(paths[0])
				if a:place == 0
					execute "rightbelow vsplit " . full_path
				else
					execute ":edit " . full_path
				endif
			endif
		endif
	endif

endfunction
