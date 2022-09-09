" ------ General settings ------
let mapleader = " " " Leader key
let maplocalleader = "," " Local leader key

" Mapping to visually select and perform operation _within a line_
" 'il' => 'inside line' (without rightmost whitespace nor newline)
onoremap <silent> il :<C-u>execute "normal!_vg_"<cr>
xnoremap <silent> il :<C-u>execute "normal!_vg_"<cr>

nnoremap gF <C-w><C-f><C-w>L

" Create a view when quiting a file and loading it when entering back
augroup viewgroup
	autocmd!
  " Resize the splits when Vim is itself resized
  autocmd VimResized * wincmd =
augroup END

augroup mailcommand
	autocmd!
	autocmd FileType mail syntax match Comment "^\s*#.*$"
	autocmd FileType mail syntax match GruvboxGreen "^\s*##.*$"
	autocmd FileType mail let b:surround_34 = "“\r”"
	" autocmd FileType mail iabbrev .. ∙
augroup END

nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
" TODO: quelque chose comme ça
"command! -nargs=1 Swap normal!:s/^\(.*\)<q-args>\(.*\)$/\2<q-args>\1/

" Netrw
let g:netrw_liststyle= 3 " Open netrw in tree mode
let g:netrw_banner= 0 " Remove the banner
let g:netrw_winsize= 25

" Stolen from Gary Bernhardt
" Indent if we're at the beginning of a line. Else, do completion.
" function! InsertTabWrapper()
" 	let col = col('.') - 1
" 	if !col || getline('.')[col - 1] !~ '\k'
" 		return "\<tab>"
" 	else
" 		return "\<c-p>"
" 	endif
" endfunction
" inoremap <expr> <tab> InsertTabWrapper()
" inoremap <s-tab> <c-n>

autocmd BufEnter * if &diff | nnoremap <cr> :diffput<cr> | endif

function! Shebang()
  if &ft == 'python'
    0put='#!/usr/bin/env python3'
  elseif &ft == 'sh'
    0put='#!/bin/bash'
  elseif &ft == 'zsh'
    0put='#!/bin/zsh'
  endif
endfunction
command! Shebang silent call Shebang()

" ------ Language specifics ------
"  == LaTeX =
" Tells vim to always expects LaTeX code (instead of plain tex code) when reading a .tex file
let g:tex_flavor = "latex"

function! ItemIfEnv()
  let l:env_found = 0
  for l:line in reverse(getline(1, line(".")))
    if l:line =~ '^\s*\\end{itemize}' || l:line =~ '^\s*\\end{enumerate}' || l:line =~ '^\s*\\end{description}'
      break
    elseif l:line =~ '^\s*\\begin{itemize}' || l:line =~ '^\s*\\begin{enumerate}' || l:line =~ '^\s*\\begin{description}'
      let l:env_found = 1
      break
    endif
  endfor
  return l:env_found
endfunction

" Remapping for LaTeX
augroup latexgroup
	autocmd!
  " Uses 'e' for surround inside inline math
  autocmd FileType tex let b:surround_101 = "\\(\r\\)"

  " Uses 'b' for surround inside textbf (bold text)
  autocmd FileType tex let b:surround_98 = "\\textbf{\r}"

  " Uses '"' for surround with LaTeX quotes
  autocmd FileType tex let b:surround_34 = "``\r''"
	autocmd BufEnter *.tex inoremap <buffer> <expr> <cr> ItemIfEnv() ? "\n\\item " : "\n"
	autocmd BufEnter *.tex inoremap <buffer> <S-cr> <cr>
	autocmd BufEnter *.tex nnoremap <buffer> <expr> o ItemIfEnv() ? "o\\item <Esc>==A" : "o"

  " Make a visual line selection into an itemize environment; each line being
  " an item
  autocmd FileType tex vnoremap <buffer> <C-l> _`<O\begin{itemize}`>o\end{itemize}gv:normal!I\item 

  " Remap 'I' so that it starts after '\item'
  autocmd FileType tex nnoremap <buffer> <expr> I getline('.') =~ '^\s*\\item' ? "_Wi" : "I"

  " TODO find a way to apply that to all “natural language” filetypes
  autocmd FileType tex iabbrev THe The
  autocmd FileType tex iabbrev THis This
  autocmd FileType tex iabbrev THere There
augroup END

augroup markdowngroup
	autocmd!
  " surround with code block with c
  autocmd FileType markdown let b:surround_99 = "```\n\r\n```"
augroup END

augroup shell
	autocmd BufNewFile *.sh 0put ='#!/bin/bash'
  autocmd FileType sh nnoremap <buffer> <cr> :!%:p<cr>
augroup END

augroup cppgroup
	autocmd!
	autocmd FileType cpp iabbrev <buffer> s_ size_t
augroup END

" Python specifics
augroup pythongroup
	autocmd!
	" autocmd FileType python nnoremap <buffer> <cr> :!./%<cr>
	autocmd BufNewFile *.py silent !chmod u+x %
	autocmd BufNewFile *.py 0put ='#!/usr/bin/env python3'
augroup END

function! CheckSpecialCommand()
	let s:command = substitute(getline(2), "^#\s*", "", "")
	execute "!".s:command
endfunction

" Rust specifics
let g:rust_fold = 1
" autocmd FileType rust compiler cargo
" autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!
" autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
" autocmd FileType rust setlocal tags+=rusty-tags.vi

" Redirect the output of a Vim or external command into a scratch buffer
" By romainl
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" (Crudely) Modified to open the output in a new split only if the current
" buffer isn't empty
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	if line('$') != 1 || getline(1) != ''
		vnew
	endif
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

function! New(mods)
	exe a:mods . ' new'
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
endfunction
command! New silent call New(<q-mods>)

function! HlSearch()
  if &hlsearch
    setlocal nohlsearch
    redraw
    return ''
  else
    setlocal hlsearch
    return '/'
  endif
endfunction
nnoremap <expr> <C-s> HlSearch()
" nnoremap <expr> <C-s> &hlsearch ? ":set nohlsearch\<cr>" : ":set hlsearch \<cr>/"

" From https://stackoverflow.com/a/6271254
function! Get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! SearchVisualSelection()
  let l:vis_select = Get_visual_selection()
  return "/".l:vis_select
endfunction

" ------ Plugin settings ------
" Pear tree
let g:pear_tree_repeatable_expand = 0

" Nvim-ipy
let g:nvim_ipy_perform_mappings = 0
augroup jupyter
	autocmd!
  autocmd BufNewFile,BufRead *.ipy setlocal filetype=python

  autocmd BufNewFile,BufRead *.ipy nmap <buffer> <silent> <F8> <Plug>(IPy-Interrupt)
  autocmd BufNewFile,BufRead *.ipy nmap <buffer> <silent> <F9> <Plug>(IPy-Terminate)

  autocmd BufNewFile,BufRead *.ipy nmap <buffer> <silent> <cr> <Plug>(IPy-RunCell)
  autocmd BufNewFile,BufRead *.ipy nmap <buffer> <silent> <F5> <Plug>(IPy-RunAll)
  autocmd BufNewFile,BufRead *.ipy nmap <buffer> <silent> <F6> <Plug>(IPy-Run)
  autocmd BufNewFile,BufRead *.ipy vmap <buffer> <silent> <cr> <Plug>(IPy-Run)

  autocmd FileType python nnoremap <buffer> go o##<cr>##<Up><cr>
  autocmd FileType python vnoremap <buffer> go <esc>mb`<O##<esc>`>o##<esc>`b
augroup END

" jedi-vi
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = ''
