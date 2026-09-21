-- Leader key
vim.g.mapleader = ' '

-- UI
vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.colorcolumn = '120'
vim.opt.pumheight = 10
vim.opt.shortmess:append('CFOSWaco') -- gunakan append agar tidak overwrite default
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'
vim.opt.winborder = 'rounded'
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'list:-1'
vim.opt.linebreak = true
vim.opt.list = true

-- Indent & Tabs
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Editing
vim.opt.formatoptions = 'rqnl1j'
vim.opt.spelloptions = 'camel'
vim.opt.virtualedit = 'block'

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.infercase = true

-- Performance
-- vim.opt.updatetime = 300
-- vim.opt.timeoutlen = 500

-- Files
vim.opt.swapfile = false
vim.opt.writebackup = false

-- Syntax & Plugins
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then
  vim.cmd('syntax enable')
end
