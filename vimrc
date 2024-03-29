" Plugins
call plug#begin('~/.config/nvim/vim-plug')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'markonm/traces.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-dispatch'
Plug 'sirver/UltiSnips'
Plug 'lervag/vimtex'

Plug 'rbong/vim-buffest'
Plug 'tmsvg/pear-tree', {'for': 'python'}
Plug 'bfredl/nvim-ipy', {'for': 'python'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug '~/Src/lingua-franca.vim-git/'

if has('nvim') && version >= 0.5.0
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'neovim/nvim-lspconfig'
endif

call plug#end()

" ------ General settings ------
let mapleader = " " " Leader key
let maplocalleader = "," " Local leader key
set history=10000 " Maximum value
language C

" Buffer and quickfix list navigation
nnoremap <silent> L :bnext<cr>
nnoremap <silent> H :bprevious<cr>
nnoremap <Down> :cnext<cr>
nnoremap <Up> :cprevious<cr>

" Mapping to visually select and perform operation _within a line_
" 'il' => 'inside line' (without rightmost whitespace nor newline)
onoremap <silent> il :<C-u>execute "normal!_vg_"<cr>
xnoremap <silent> il :<C-u>execute "normal!_vg_"<cr>

" Open and close the quickfix window with the same key
nnoremap <silent> <expr> ù len(filter(range(1, winnr('$')), 'getbufvar(winbufnr(v:val), "&buftype") == "quickfix"')) ? ":cclose<cr>" : ":copen<cr>"

nnoremap gF <C-w><C-f><C-w>L

set showcmd
set incsearch
set autowrite " Automatically save before commands like :next and :make
set nomodeline
set linebreak
set breakindent
set showbreak=˪
set noshowmatch
set wildmenu
set hidden " Hide buffers when they are abandoned
set autoread
set wildignore=*.aux,*.log
set wildmode=longest:lastused:full
set undofile

" Nvim options
set nohlsearch

" Show the number of the line you're in and the relative number of the lines above and below
set number
set relativenumber

" Open splits in a normal way
set splitbelow
set splitright

" Regarding tabs and indentation
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent " Copy indent from current line when starting a new line

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

vnoremap + "+y

" Join in visual mode
vnoremap <C-J> J

" Miscellaneous remapping
inoremap <C-a> <Esc>A
inoremap <C-e> <C-r>=execute("")<left><left>

" Turns out the following isn't the default behaviour of ]p !
nnoremap ]p p'[=']

" Always stays on the same column when redrawing the screen
nnoremap z. zz

" Substitute only in selection
vnoremap s :s/\%V

" autocmd ShellCmdPost * echom(@:)
" augroup generalautocmd
"   autocmd ShellCmdPost * if @: =~ '\M!chmod' && getline(1) !~ '^#!' | echohl WarningMsg | echo 'Achtung' | echohl None | endif
" augroup END

if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ --glob\ '!.git'
endif

" Create a view when quiting a file and loading it when entering back
augroup viewgroup
	autocmd!
	autocmd BufWrite ~/Src/** mkview
	autocmd BufWinEnter ~/Src/** silent! loadview

  " Resize the splits when Vim is itself resized
  autocmd VimResized * wincmd =
augroup END

augroup mailcommand
	autocmd!
	autocmd BufEnter *.mail setlocal ft=mail
	autocmd FileType mail setlocal spell
	autocmd FileType mail setlocal spelllang=en,fr,de
	autocmd BufEnter *.fr.* setlocal spelllang=fr
	autocmd BufEnter *.de.* setlocal spelllang=de
	autocmd BufEnter *.en.* setlocal spelllang=en
	autocmd FileType mail nnoremap <buffer> j gj
	autocmd FileType mail nnoremap <buffer> k gk
  autocmd FileType mail nnoremap <buffer> <cr> vipgq
	autocmd FileType mail setlocal nonumber norelativenumber
	autocmd FileType mail setlocal foldcolumn=0 textwidth=80
	autocmd FileType mail syntax match Comment "^\s*#.*$"
	autocmd FileType mail syntax match GruvboxGreen "^\s*##.*$"
	autocmd FileType mail iabbrev -- —
	autocmd FileType mail let b:surround_34 = "“\r”"
	" autocmd FileType mail iabbrev .. ∙
	autocmd FileType mail nnoremap <buffer> <expr> I getline('.') =~ '^\s*-' ? "_Wi" : "I"
augroup END

set gdefault
"s/x/y substitutes for the whole line
"s/x/y/g substitutes for the first instance only

" Fuzzy finder
set rtp+=~/.fzf
inoremap <C-f> <Esc>:FZF<Enter>
noremap <C-f> :FZF<Enter>
if has('nvim')
	let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
endif

" Change split in one less key press
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Disable Ex mode and the S/s keys in normal mode
nnoremap Q <Nop>
nnoremap U <Nop>

nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
nnoremap s :%s/
nnoremap S :s/
" TODO: quelque chose comme ça
"command! -nargs=1 Swap normal!:s/^\(.*\)<q-args>\(.*\)$/\2<q-args>\1/

" Netrw
let g:netrw_liststyle= 3 " Open netrw in tree mode
let g:netrw_banner= 0 " Remove the banner
let g:netrw_winsize= 25
let g:netrw_browsex_viewer= "/usr/bin/firefox" " Bug au niveau de Vim/Netrw : https://github.com/vim/vim/issues/4738

" Let escape go in Terminal Normal mode
" (use i to go back into Terminal mode)
" TODO find a way to conciliate this with FZF
" tnoremap <Esc> <C-W>N

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

" let g:surround_113 = "“\r”"

" ------ Appearance ------
" set termguicolors
colorscheme gruvbox
" Small adjusment on gruvbox:
" hi! CursorLine guibg=#33302e

set background=dark
set foldcolumn=1 "Set the foldcolumn

" Use nicer symbols to symbolise invisible characters when list is enabled
set listchars=tab:▸\ ,eol:¬,space:␣

" Setting the statusline
set laststatus=2
set statusline=%m\ %f\ %=\ %y\ %r

" Cursorline only on the 'focused' buffer
augroup cursorlinegroup
	autocmd!
	autocmd BufEnter * setlocal cursorline
	autocmd BufLeave * setlocal nocursorline
augroup END

" ------ Language specifics ------
"  == Lingua Franca ==
augroup lfgroup
  autocmd!
  autocmd FileType linguafranca command! -nargs=1 Import call LFImport(<q-args>)
  " autocmd FileType linguafranca command! -nargs=1 Import silent call LFImport(<q-args>)
augroup END

"  == LaTeX ==
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

" function LatexItemize()
"   normal!_
"   normal!`<O\begin{itemize}
"   normal!>o\end{itemize}
" endfunction
" Remapping for LaTeX
augroup latexgroup
	autocmd!
  " Uses 'e' for surround inside inline math
  autocmd FileType tex let b:surround_101 = "\\(\r\\)"

  " Uses 'b' for surround inside textbf (bold text)
  autocmd FileType tex let b:surround_98 = "\\textbf{\r}"
  " t for typeface
  autocmd FileType tex let b:surround_116 = "\\texttt{\r}"

  " Uses '"' for surround with LaTeX quotes
  autocmd FileType tex let b:surround_34 = "``\r''"
	autocmd BufEnter *.tex inoremap <buffer> <expr> <cr> ItemIfEnv() ? "\n\\item " : "\n"
	autocmd BufEnter *.tex inoremap <buffer> <S-cr> <cr>
	autocmd BufEnter *.tex nnoremap <buffer> <expr> o ItemIfEnv() ? "o\\item <Esc>==A" : "o"

  " Make a visual line selection into an itemize environment; each line being
  " an item
  autocmd FileType tex vnoremap <buffer> <C-l> _`<O\begin{itemize}`>o\end{itemize}gv:normal!I\item 
  " autocmd FileType tex command! Clean execute("'<,'>s/\%V\\item \(\\\(item\|begin{itemize}\|end{itemize}\)\)/\1")

  " Remap 'I' so that it starts after '\item'
  autocmd FileType tex nnoremap <buffer> <expr> I getline('.') =~ '^\s*\\item' ? "_Wi" : "I"

  " TODO prune ToC
  autocmd FileType tex nnoremap <localleader>lt :call vimtex#fzf#run()<cr>

  " TODO find a way to apply that to all “natural language” filetypes
  autocmd FileType tex iabbrev THe The
  autocmd FileType tex iabbrev THis This
  autocmd FileType tex iabbrev THere There

	autocmd FileType tex setlocal spell spelllang=en
augroup END

augroup markdowngroup
	autocmd!
  " surround with code block with c
  autocmd FileType markdown let b:surround_99 = "```\n\r\n```"
  autocmd FileType markdown highlight link markdownError NONE " Disable error highlighting for underscore between \w characters
augroup END

augroup shell
	autocmd BufNewFile *.sh 0put ='#!/bin/bash'
  autocmd FileType sh nnoremap <buffer> <cr> :!%:p<cr>
augroup END
let g:sh_fold_enabled = 1
let g:is_bash         = 1
let g:sh_no_error     = 1

" TODO faire un snippet
" autocmd FileType c inoremap <buffer> ,m int main(int argc, char* argv[]){<Enter>}<Esc>O

" Remapping for C++
function! CppInit()
	silent execute "!ctags -R *"
	if !filereadable("Makefile") && !filereadable("../Makefile")
		setlocal makeprg=g++\ -std=c++11
		nnoremap <buffer> <cr> :make! %<cr>
	endif
endfunction

" autocmd BufRead,FileType cpp call CppInit()
augroup cppgroup
	autocmd!
	autocmd FileType cpp inoremap <buffer> ,m int main(int argc, char* argv[]){<Enter>}<Esc>O
	autocmd FileType cpp iabbrev <buffer> s_ size_t
	autocmd FileType cpp nnoremap <leader>r I#f/r wi"A"==
	autocmd FileType linguafranca nnoremap <leader>r I#f/r wi"A"==
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

" Lingua Franca
augroup lfgroup
  " surround with '='
  autocmd FileType linguafranca let b:surround_61 = "{=\r=}"
augroup END

" Rust specifics
let g:rust_fold = 1
" autocmd FileType rust compiler cargo
" autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!
" autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
" autocmd FileType rust setlocal tags+=rusty-tags.vi

" Use spell for gitcommit
augroup gitcommitgroup
	autocmd!
	autocmd FileType gitcommit setlocal spell
	autocmd FileType gitcommit setlocal spelllang=en
augroup END

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

cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

" TODO find a good way to insert non greedy * in command line
" cabbrev nongreedy \{-}

function HlSearch()
  if &hlsearch
    set nohlsearch
    redraw
    return ''
  else
    set hlsearch
    return '/'
  endif
endfunction
nnoremap <expr> <C-s> HlSearch()
" nnoremap <expr> <C-s> &hlsearch ? ":set nohlsearch\<cr>" : ":set hlsearch \<cr>/"

source ~/.config/nvim/private.vim

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

" function! SearchVisualSelection()
"   let l:vis_select = Get_visual_selection()
"   return "/".l:vis_select
" endfunction

" vnoremap / /<c-r>=Get_visual_selection()
" vnoremap <expr> / SearchVisualSelection()

augroup cgroup
  autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
augroup END

" ------ Plugin settings ------

" UltiSnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" Vimtex
let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : 'outpdf',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}
let g:vimtex_view_method = 'zathura'
let g:vimtex_toc_config_matchers = {
      \ 'beamer_frame': {'disable': 1},
      \}

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

  " autocmd BufNewFile,BufRead *.ipy nmap <silent> <Plug>(IPy-RunOp)
  " autocmd BufNewFile,BufRead *.ipy nmap <silent> <Plug>(IPy-Complete)
  " autocmd BufNewFile,BufRead *.ipy nmap <silent> <Plug>(IPy-WordObjInfo)
augroup END

" jedi-vi
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = ''

luafile ~/.config/nvim/lua_config.lua
" nnoremap <Space>rn :lua vim.lsp.buf.rename()<cr>

command! -nargs=1 CheckWords 
      \ vimgrep "\c\(\<we\>\|\<our\>\|couldn't\|isn't\|can't\|weren't\|woudln't\|didn't\|haven't\|don't\)" <args>
command! -nargs=1 CheckFigures vimgrep '\c[^{\\]\<\(section\|figure\|listing\)\>' <args>

let g:gruvbox_improved_warnings = 1

command! Date put = strftime(\"%A %d %B %Y\")
