" Plugins
call plug#begin('~/.config/nvim/vim-plug')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'markonm/traces.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-dispatch'
Plug 'sirver/UltiSnips'
Plug 'lervag/vimtex'
call plug#end()

" ------ General settings ------
set nocompatible
" let mapleader = " " " Leader key
let maplocalleader = "," " Leader key
set history=10000 " Maximum value
language C

" Buffer and quickfix list navigation
nnoremap <Right> :bnext<cr>
nnoremap <Left> :bprevious<cr>
nnoremap <Down> :cnext<cr>
nnoremap <Up> :cprevious<cr>

" Open and close the quickfix window with the same key
nnoremap <expr> ù len(filter(range(1, winnr('$')), 'getbufvar(winbufnr(v:val), "&buftype") == "quickfix"')) ? ":cclose<cr>" : ":copen<cr>" 

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
set wildignore=*.aux,*.log

" Nvim options
set nohlsearch

" Puts the terminal output at the bottom of the screen instead of having an alternate screen
" Stolen from Gary Bernhardt who took it here : http://www.shallowsky.com/linux/noaltscreen.html
" set t_ti= t_te=

" Undofile
" set undofile
" set undodir=~/.vim/undodir/

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

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

vnoremap + "+y

" Join in visual mode
vnoremap <C-J> J

" Miscellaneous remapping
inoremap <C-a> <Esc>A
" Turns out the following isn't the default behaviour of ]p !
nnoremap ]p p'[=']

" Always stays on the same column when redrawing the screen
nnoremap z. zz

" Substitute only in selection
vnoremap s :s/\%V


" Create a view when quiting a file and loading it when entering back
augroup viewgroup
	autocmd!
	autocmd BufWrite ~/Src/** mkview
	autocmd BufWinEnter ~/Src/** silent! loadview
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
	" autocmd FileType mail iabbrev .. ∙
augroup END

set gdefault 
"s/x/y substitutes for the whole line
"s/x/y/g substitutes for the first instance only

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
nnoremap U <Nop>

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
tnoremap <Esc> <C-W>N

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

" ------ Appearance ------
colorscheme gruvbox 
set background=dark
set foldcolumn=1 "Set the foldcolumn

" Use nicer symbols to symbolise invisible characters when list is enabled
set listchars=tab:▸\ ,eol:¬,space:␣

" Setting the statusline
set laststatus=2
set statusline=%m\ Buf:%n\ %f\ %=\ %y\ %r

" Cursorline only on the 'focused' buffer
augroup cursorlinegroup
	autocmd!
	autocmd BufEnter * setlocal cursorline
	autocmd BufLeave * setlocal nocursorline
augroup END

" Automatically copies unloaded scratch buffer to clipboard
if has('clipboard')
	augroup scratchgroup
		autocmd!
		autocmd BufUnload * if(&buftype == "nofile") | execute 'normal! ggVG"+y' | endif
	augroup END
endif



" ------ Language specifics ------
"  == LaTeX =
" Tells vim to always expects LaTeX code (instead of plain tex code) when reading a .tex file
let g:tex_flavor = "latex"
" let g:tex_conceal = 'admg'

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
  autocmd FileType tex let b:surround_101 = "\\(\r\\)"
  autocmd FileType tex let b:surround_98 = "\\textbf{\r}"
	autocmd BufEnter *.tex inoremap <buffer> <expr> <cr> ItemIfEnv() ? "\n\\item " : "\n"
	autocmd BufEnter *.tex inoremap <buffer> <S-cr> <cr>
	autocmd BufEnter *.tex nnoremap <buffer> <expr> o ItemIfEnv() ? "o\\item <Esc>==A" : "o"
	" autocmd BufEnter *.tex set conceallevel=1
augroup END

" Shebangs
augroup shebanggroup
	autocmd!
	autocmd BufNewFile *.sh 0put ='#!/bin/bash'
	autocmd BufNewFile *.py 0put ='#!/usr/bin/env python3'
augroup END

" Remapping for C
augroup cgroup
	autocmd!
	autocmd FileType c inoremap <buffer> ,m int main(int argc, char* argv[]){<Enter>}<Esc>O
	autocmd FileType c nnoremap <buffer> <cr> :make<cr>
	autocmd FileType c nnoremap <buffer> <F5> :make run<cr>
augroup END

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
augroup END

" Python specifics
augroup pythongroup
	autocmd!
	autocmd FileType python inoremap <buffer> " ""<Left>
	autocmd FileType python inoremap <buffer> <C-e> self.
	autocmd FileType python inoremap <buffer> ' ''<Left>
	autocmd FileType python inoremap <buffer> ( ()<Left>
	autocmd FileType python nnoremap <buffer> <cr> :w\|:!./%<cr>
	autocmd BufNewFile *.py silent !chmod u+x %
	" autocmd BufNewFile,FileType python silent !chmod u+x %
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

source ~/.config/nvim/private.vim

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
" let g:vimtex_view_general_options = 'outpdf/@pdf'
" let g:vimtex_view_zathura_options = 'outpdf/@pdf'
