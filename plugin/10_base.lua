vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim"
})

vim.g.mapleader    = ' '
vim.opt.clipboard  = 'unnamedplus'
vim.opt.number     = true
-- vim.opt.relativenumber = true
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.signcolumn = "yes"
vim.opt.wrap       = true
vim.o.laststatus   = 3


-- indent
vim.o.shiftwidth   = 2
vim.o.expandtab    = true
vim.o.autoindent   = true
vim.o.smartindent  = true
vim.o.smartindent  = true

vim.o.swapfile     = false
vim.o.writebackup  = false
vim.o.cursorline   = true

-- search
vim.o.ignorecase   = true
vim.o.incsearch    = true
vim.o.smartcase    = true

vim.opt.statusline = "%<%f %h%m%r%=%{coc#status()} %{get(b:,'coc_current_function','')} %-14.(%l,%c%V%) %P"
