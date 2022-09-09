vim.cmd('source ~/.config/nvim/initialization.vim')

vim.cmd 'packadd packer.nvim'

require('packer').startup(function()
	use "wbthomason/packer.nvim" 
	use 'tpope/vim-commentary'
	use 'tpope/vim-surround'
	use 'markonm/traces.vim'
	use 'godlygeek/tabular'
	use 'tpope/vim-dispatch'
	use 'lervag/vimtex'
	use 'L3MON4D3/LuaSnip'
	use 'rbong/vim-buffest'
	use 'neovim/nvim-lspconfig'
	use 'dhruvasagar/vim-table-mode'
	use 'nvim-treesitter/nvim-treesitter'

	use {'tmsvg/pear-tree', ft = 'python'}
	use {'bfredl/nvim-ipy', ft = 'python'}

	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use 'tpope/vim-fugitive'

end)

require('snippets')

-- TODO
-- play with 'tabline' to remove this awful X
-- see :h setting-tabline

vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.autowrite = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.wildmenu = true
vim.opt.hidden = true
vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autoindent = true
vim.opt.gdefault = true

vim.opt.modeline = false
vim.opt.showmatch = false
vim.opt.hlsearch = false

vim.opt.history = 10000
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.laststatus = 2

vim.opt.mouse = 'n'
vim.opt.foldcolumn = '1'
vim.opt.showbreak = '˪'
vim.opt.background = 'dark'
vim.opt.statusline = '%m %= %f %= %y %r %{FugitiveStatusline()}'

vim.opt.listchars = {
	tab = '▸ ',
	eol = '¬',
	space = '␣'
}

vim.opt.wildmode = {
	'longest',
	'lastused',
	'full'
}

vim.opt.wildignore = {
	'*.aux', '*.log'
}

vim.keymap.set('n', 'L', function() vim.cmd 'bnext' end)
vim.keymap.set('n', 'H', function() vim.cmd 'bprevious' end)

vim.keymap.set('n', ']]', function() vim.cmd 'tabnext' end)
vim.keymap.set('n', '[[', function() vim.cmd 'tabprevious' end)

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', 's', ':%s/')
vim.keymap.set('n', 'S', ':s/')

-- Paste and indent what's been pasted
vim.keymap.set('n', ']p', "p'[=']")

-- Always stays on the same column when centering the screen
vim.keymap.set('n', 'z.', 'zz')

vim.keymap.set('i', '<C-a>', '<Esc>A')

local qfWrapper = function(goingUp)
	if next(vim.fn.getqflist()) then
		-- we are in QF mode
		local infos = vim.fn.getqflist({idx = 0, size = 0})
		local id, size = infos.idx, infos.size
		if goingUp then
			if id == 1 then print('Reached the beginning of the list. Going at the end.'); vim.cmd 'silent clast' else vim.cmd 'cprevious' end
		else
			if id == size then print('Reached the end of the list. Going at the beginning.'); vim.cmd 'silent cfirst' else vim.cmd 'cnext' end
		end
	elseif next(vim.fn.getloclist(0)) then
		-- we are in LOC mode
		local infos = vim.fn.getloclist(0, {idx = 0, size = 0})
		local id, size = infos.idx, infos.size

		if goingUp then
			if id == 1 then print('Reached the beginning of the list. Going at the end.'); vim.cmd 'silent llast' else vim.cmd 'lprevious' end
		else
			if id == size then print('Reached the end of the list. Going at the beginning.'); vim.cmd 'silent lfirst' else vim.cmd 'lnext' end
		end
	else
		-- we are in Empty mode
		if goingUp then vim.cmd 'normal! k' else vim.cmd 'normal! j' end
		return
	end
end

vim.keymap.set('n', '<Up>', function() qfWrapper(true) end)
vim.keymap.set('n', '<Down>', function() qfWrapper(false) end)

-- TODO Trying to search the visual selection
local get_visual_selection = function()
	local tmp = vim.fn.getpos("'<")
	local line_start, column_start = tmp[2], tmp[3]
	tmp = vim.fn.getpos("'>")
	local line_end, column_end = tmp[2], tmp[3]
	local lines = vim.fn.getline(line_start, line_end)
	
	if not next(lines) then return nil end

	-- apparently no negative indexing with lua

end
vim.keymap.set('v', 'gg', get_visual_selection)

local nope = function() end
vim.keymap.set('n', 'gQ', nope)
vim.keymap.set('n', 'Q', nope)
vim.keymap.set('n', 'U', nope)

vim.keymap.set('v', 's', ':s/\\%V')

vim.keymap.set('c', '<C-j>', '<Down>')
vim.keymap.set('c', '<C-k>', '<Up>')

vim.keymap.set('v', '<C-j>', 'J')
vim.keymap.set('v', '+', '"+y')

-- Move visual block
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.cmd 'command Cempty call setqflist([])'

local QuickFixToggle = function()
	local expr1 = vim.fn.range(1, vim.fn.winnr('$'))
	local expr2 = 'getbufvar(winbufnr(v:val), "&buftype") == "quickfix"'

	if vim.fn.len(vim.fn.filter(expr1, expr2)) > 0 then
		vim.cmd 'cclose'
	else
		vim.cmd 'copen'
		vim.cmd 'wincmd J'
	end
end

vim.keymap.set('n', '<BS>', QuickFixToggle)

-- Files with views
local viewfiles = {
}
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = viewfiles,
	-- command = "mkview"
	callback = function()
		if not vim.opt.diff then
			vim.cmd.mkview()
		end
	end
})
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = viewfiles,
	command = "silent! loadview"
})

-------------
-- Appearance
-------------
vim.cmd 'colorscheme gruvbox'

---------------------
-- Language specifics
---------------------

-- TODO Handle binaries
-- cf :h hex-editing and :h OptionSet

local gitcommit_id = vim.api.nvim_create_augroup('gitcommit_group', {})
vim.api.nvim_create_autocmd("FileType", {
	pattern = 'gitcommit',
	group = gitcommit_id,
	callback = function() vim.opt_local.spell = true; vim.opt_local.spelllang = "en" end
})

local mail_init = function(arg)
	vim.opt_local.spell = true;
	vim.opt_local.number = false;
	vim.opt_local.relativenumber = false;
	vim.opt_local.foldcolumn = '0';
	vim.opt_local.textwidth = 80;

	vim.cmd 'iabbrev -- —'

	vim.keymap.set('n', 'j', 'gj', { buffer = true})
	vim.keymap.set('n', 'k', 'gk', { buffer = true})
	vim.keymap.set('n', '<cr>', 'vipgq', { buffer = true})

	-- Language selection logic
	vim.opt_local.spelllang = {"en", "fr", "de"}
	if string.match(arg.file, '.*%.fr%..*') then
		vim.opt_local.spelllang = "fr"
	elseif string.match(arg.file, '.*%.de%..*') then
		vim.opt_local.spelllang = "de"
	elseif string.match(arg.file, '.*%.en%..*') then
		vim.opt_local.spelllang = "en"
	end

end

local mail_autocmd = vim.api.nvim_create_augroup('mail_group', {})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = '*.mail',
	group = mail_autocmd,
	command = 'setlocal ft=mail' -- TODO: change
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = 'mail',
	group = mail_autocmd,
	callback = mail_init
})

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = '*',
-- 	-- group =, -- TODO
-- 	callback = function()
-- 		if vim.opt.diff:get() then
-- 			vim.keymap.set('n', '<Cr>', vim.cmd 'diffput')
-- 		end
-- 	end
-- })

local windows_autocmd = vim.api.nvim_create_augroup('windows_group', {})
local win_events = {
	WinEnter = true,
	VimEnter = true,
	WinLeave = false,
}
-- local win_cursorline_fn = function(arg)
-- 	vim.wo.cursorline = win_events.(arg.event)
-- end
vim.api.nvim_create_autocmd({ "WinEnter", "VimEnter" }, {
	group = windows_autocmd,
	callback = function() vim.wo.cursorline = true end
})
vim.api.nvim_create_autocmd("WinLeave", {
	group = windows_autocmd,
	callback = function() vim.wo.cursorline = false end
})

----------------
-- Plugin Config
----------------
require('telescope').setup{
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous"
			}
		}
	}
}
-- Telescope remappings
-- local opts = {
-- 	search_dirs = {'src', 'include', 'docs', 'tests', 'tools'}
-- }
-- vim.keymap.set('n', '<C-f>', function() require('telescope.builtin').find_files(opts) end)
vim.keymap.set('n', '<C-f>', require('telescope.builtin').find_files)
vim.keymap.set('n', '<C-g>', require('telescope.builtin').live_grep)

-- LSP
local lsp_enabled = true
if lsp_enabled then
	local opts = { noremap=true, silent=true, buffer = true }
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		-- vim.keymap.set('n', '<space>ca', function() vim.lsp.buf.code_action({includeDeclaration = false}) end, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, opts)
		vim.keymap.set('n', '\\', vim.diagnostic.open_float, opts)

		vim.keymap.set('n', '<space>gd', function()vim.cmd 'vsp';vim.lsp.buf.definition() end, opts)
	end

	-- TODO mapping for definition in new window

	-- Use a loop to conveniently call 'setup' on multiple servers and
	-- map buffer local keybindings when the language server attaches
	-- local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
	local servers = { 'ccls' }
	for _, lsp in pairs(servers) do
		require('lspconfig')[lsp].setup {
			on_attach = on_attach
		}
	end
end

-- VimTeX options
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_latexmk = {
     build_dir = 'out',
     callback = 1,
     continuous = 1,
     executable = 'latexmk',
     hooks = {},
     options = {
	'-verbose',
	'-file-line-error',
	'-synctex=1',
	'-interaction=nonstopmode',
	}
    }


vim.g.do_filetype_lua = 1
