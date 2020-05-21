" ===== INSTALLED PLUGINS ===============
" vim-surrond
" tabular
" traces.vim
" vim-commentary
" FZF
" =======================================

" ------ General settings ------
set nocompatible
let mapleader = " " " Leader key
set history=10000 " Maximum value

" Buffer and quickfix list navigation
nnoremap <Right> :bnext<cr>
nnoremap <Left> :bprevious<cr>
nnoremap <Down> :cnext<cr>
nnoremap <Up> :cprevious<cr>

" Open and close the quickfix window with the same key
nnoremap <expr> ù len(filter(range(1, winnr('$')), 'getbufvar(winbufnr(v:val), "&buftype") == "quickfix"')) ? ":cclose<cr>" : ":copen<cr>" 

" Enables syntax highlighting by default.
if has("syntax")
	syntax on
endif

" Load the indentation rules and plugins according to the detected filetype.
if has("autocmd")
	filetype plugin indent on
endif

set showcmd   " Show (partial) command in status line.
set showmatch " Show matching brackets.
set incsearch " Incremental search
set autowrite " Automatically save before commands like :next and :make
set nomodeline
set linebreak
set breakindent
set showbreak=˪
set noshowmatch
set wildmenu
set hidden " Hide buffers when they are abandoned
set autoindent " Copy indent from current line when starting a new line
set autoread

" Puts the terminal output at the bottom of the screen instead of having an alternate screen
" Stolen from Gary Bernhardt who took it here : http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" Undofile
set undofile
set undodir=~/.vim/undodir/

" Show the number of the line you're in and the relative number of the lines above and below
set number
set relativenumber

" Open splits in a normal way
set splitbelow
set splitright

" Regarding tabs and indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Join in visual mode
vnoremap <C-J> J

" Miscellaneous remapping
inoremap <C-a> <Esc>A
" Turns out the following isn't the default behaviour of ]p !
nnoremap ]p p'[=']

" Substitute only in selection
vnoremap s :s/\%V

" Create a view when quiting a file and loading it when entering back
" autocmd BufWrite *.* mkview
" autocmd BufWinEnter *.* silent loadview

set gdefault 
"s/x/y substitutes for the whole line
"s/x/y/g substitutes for the first instance only

" Changing the location of the .viminfo file
" set viminfofile="/home/hugo/.hugo/.vim/viminfo"
set viminfo+=n~/.vim/viminfo

" Fuzzy finder
set rtp+=~/.fzf
inoremap <C-f> <Esc>:FZF<Enter>
noremap <C-f> :FZF<Enter>
if has('nvim')
	let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif

" Change split in one less key press
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Disable Ex mode and the S/s keys in normal mode
nnoremap Q <Nop>
nnoremap S <Nop>
nnoremap s <Nop>
nnoremap U <Nop>

" Netrw
let g:netrw_liststyle= 3 " Open netrw in tree mode
let g:netrw_banner= 0 " Remove the banner
let g:netrw_winsize= 25
let g:netrw_browsex_viewer= "/usr/bin/firefox" " Bug au niveau de Vim/Netrw : https://github.com/vim/vim/issues/4738
" En attendant un fix... pollue le répertoire mais on est pas à ça près...
" From : https://stackoverflow.com/questions/9458294/open-url-under-cursor-in-vim-with-browser/20177492#20177492
nmap gx yiW:!firefox <cWORD><CR> <C-r>" & <CR><CR>

" Let escape go in Terminal Normal mode
" (use i to go back into Terminal mode)
tnoremap <Esc> <C-W>N

" Stolen from Gary Bernhardt
" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" ------ Appearance ------
colorscheme gruvbox 
set background=dark
set cursorline
set foldcolumn=1 "Set the foldcolumn

" Use nicer symbols to symbolise invisible characters when list is enabled
set listchars=tab:▸\ ,eol:¬

" Setting the statusline
set laststatus=2
set statusline=%m\ Buf:%n\ %f\ %=\ %y\ %r

" ------ Language specifics ------
"  == LaTeX =
" Tells vim to always expects LaTeX code (instead of plain tex code) when reading a .tex file
let g:tex_flavor = "latex"

" Create a template when creating a new .tex file
" autocmd BufNewFile *.tex 0r ~/Latex/.template_latex

" Remapping for LaTeX
autocmd FileType tex inoremap <buffer> ,li \begin{itemize}<Enter>\end{itemize}<Enter><++><Esc>kO\item<Space>
autocmd FileType tex inoremap <buffer> ,i \item<Space>
autocmd FileType tex inoremap <buffer> ,desc \begin{description}<Enter>\end{description}<Enter><++><Esc>kO\item[]<Space><++><Esc>F]i
autocmd FileType tex inoremap <buffer> ,di \item[]<Space><++><Esc>F]i
autocmd FileType tex setlocal makeprg=pdflatex
autocmd FileType tex nnoremap <buffer> <cr> :make<cr>

" Shebangs
autocmd BufNewFile *.sh 0put ='#!/bin/bash'
autocmd BufNewFile *.py 0put ='#!/usr/bin/env python3'

" Remapping for C
autocmd FileType c inoremap <buffer> ,m int main(int argc, char* argv[]){<Enter>}<Esc>O
" autocmd FileType c inoremap <buffer> " ""<Left>
" autocmd FileType c inoremap <buffer> ' ''<Left>
" autocmd FileType c inoremap <buffer> ( ()<Left>
" autocmd FileType c inoremap <buffer> {<Enter> {<Enter>}<Esc>O

" Remapping for C++
function! CppInit()
	silent execute "!ctags -R *"
	if !filereadable("Makefile") && !filereadable("../Makefile")
		setlocal makeprg=g++\ -std=c++11
		nnoremap <buffer> <cr> :make! %<cr>
	endif
endfunction

" TODO installer cscope
autocmd BufRead,FileType cpp call CppInit()
autocmd FileType cpp inoremap <buffer> ,m int main(int argc, char* argv[]){<Enter>}<Esc>O
autocmd FileType cpp inoremap <buffer> " ""<Left>
autocmd FileType cpp inoremap <buffer> ' ''<Left>
autocmd FileType cpp inoremap <buffer> ( ()<Left>
autocmd FileType cpp inoremap <buffer> {<Enter> {<Enter>}<Esc>O
autocmd FileType cpp iabbrev <buffer> s_ size_t
" autocmd FileType cpp inoremap <buffer> t- this->

" Python specifics
autocmd FileType python inoremap <buffer> " ""<Left>
autocmd FileType python inoremap <buffer> <C-e> self.
autocmd FileType python inoremap <buffer> ' ''<Left>
autocmd FileType python inoremap <buffer> ( ()<Left>
autocmd FileType python nnoremap <buffer> <cr> :w\|:!./%<cr>
autocmd BufNewFile *.py silent !chmod u+x %
" autocmd BufNewFile,FileType python silent !chmod u+x %

function! CheckSpecialCommand()
	let s:command = substitute(getline(2), "^#\s*", "", "")
	execute "!".s:command
endfunction

" Rust specifics
let g:rust_fold = 1
" autocmd FileType rust compiler cargo
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
autocmd FileType rust setlocal tags+=rusty-tags.vi

" Use spell for gitcommit
autocmd FileType gitcommit setlocal spell
autocmd FileType gitcommit setlocal spelllang=en

" ALE
let g:ale_sh_shellcheck_executable = "/usr/bin/shellcheck"
let g:ale_linters = {'rust': ['cargo']}

" Crutch for the lack of clipboard support
if !has('clipboard')
	function! Clip()
		let tmpfile = tempname()
		silent! execute "write " . tmpfile
		silent! execute '!xclip -selection clipboard %'
	endfunction
	nnoremap <F1> :call Clip()<cr>
end

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

" Vimwiki
let vw_syntax = {'python': 'python', 'c': 'c', 'c++': 'cpp'}
let g:vimwiki_list = [{
			\ 'path': '~/.vimwiki/', 
			\ 'nested_syntaxes': vw_syntax,
			\ 'path_html': '~/.vimwiki/auto_html/',
			\ 'template_path': '~/.vimwiki/.templates/',
			\ 'template_default': 'default',
			\ 'template_ext': '.html',
			\ 'vimwiki_hl_headers': 1,
			\ }]

command! Vw VimwikiIndex
" autocmd filetype vimwiki setlocal textwidth=99
let g:vimwiki_url_maxsave=5
" TODO : mettre les bonnes abbréviations pour les bons cours
autocmd BufEnter /home/hugo/TUD/SW_fault_tolerance/* iabbrev ft fault tolerance
autocmd BufEnter /home/hugo/TUD/SW_fault_tolerance/* iabbrev sw software
autocmd BufEnter /home/hugo/TUD/SW_fault_tolerance/* iabbrev hw hardware
autocmd BufEnter /home/hugo/TUD/SW_fault_tolerance/* iabbrev e2e end-to-end
autocmd BufEnter /home/hugo/TUD/SW_fault_tolerance/* iabbrev le link encryption
autocmd BufEnter /home/hugo/TUD/SW_fault_tolerance/* iabbrev nw network
autocmd BufEnter /home/hugo/TUD/SW_fault_tolerance/* iabbrev nws networks

let g:vimwiki_global_ext = 0

" function! AutoFilename()
" 	let line=getline('.')
" endfunction

" autocmd BufWritePost vimrc source $MYVIMRC
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
