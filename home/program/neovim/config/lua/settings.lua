vim.o.undofile = true -- Write undo files
vim.o.undolevels = 1000 -- Increase undo levels
vim.o.backup = false -- No file backup

vim.o.completeopt = "menuone,noselect" -- Completion options
vim.o.hidden = true -- Enable modified buffers in background
vim.o.ignorecase = true -- Ignore case
vim.o.inccommand = "nosplit" -- Show effects of a command incrementally
vim.o.joinspaces = false -- No double spaces with join after a dot
vim.o.scrolloff = 4 -- Lines of context
vim.o.fileencoding = "utf-8" -- Encode files using UTF-8
vim.o.termguicolors = true -- True color support
vim.o.background = "dark" -- Always dark background
vim.o.wildmenu = true -- Command-line completion mode
vim.o.wildmode = "longest,list,full" -- Command-line completion mode
vim.o.cmdheight = 2 -- Command-line height
vim.o.timeoutlen = 500 -- to to wait for mapped sequence to complete

vim.o.errorbells = false -- No sound on errors
vim.o.visualbell = false
vim.o.clipboard = "unnamedplus" -- OS and tmux clipboard transparent access

-- GUI
-- TODO: find how to remove -T
-- vim.o.guioptions-=T                    -- Remove toolbar
vim.o.winaltkeys = "no" -- Disable ALT keys for menu

-- Window
vim.wo.signcolumn = "number" -- Always show the sign column
vim.wo.list = false -- Don't show invisible characters by default
vim.wo.listchars = "tab:▸ ,eol:¬"

-- Those commands must be executed using `vim.cmd` due to:
--     https://github.com/neovim/neovim/issues/12978
vim.cmd [[
set autoindent
set expandtab
set shiftwidth=4
set smartindent
set softtabstop=4
set tabstop=4
set textwidth=80
set colorcolumn=+1

augroup myfiletypes_group
  " Clear old autocmds in group
  autocmd!
  autocmd FileType ruby,eruby,yaml,ru set ai sw=2 sts=2 et
  autocmd FileType lua set ai sw=2 sts=2 et
  autocmd FileType python set ai sw=4 sts=4 et ts=8
  autocmd FileType sh set noet ci pi sts=0 sw=8 ts=8
  autocmd FileType javascript,json set ai sw=2 sts=2 et
  autocmd FileType java set ai sw=4 sts=4 et
  autocmd FileType html set ai sw=2 sts=2 et
  autocmd FileType objc set ai sw=4 sts=4 et
  autocmd FileType sql set ai sw=4 sts=4 et
  autocmd FileType puppet set ai sw=2 sts=2 et
  autocmd FileType spec set ai sw=2 sts=2 et
  autocmd FileType properties set ai sw=2 sts=2 et
  autocmd FileType jproperties set ai sw=2 sts=2 et
  autocmd FileType xml set ai sw=4 sts=4 et
augroup END
]]

-- show extra whitespaces
vim.cmd [[ highlight ExtraWhitespace ctermbg=167 guibg=#fb4934 ]]
