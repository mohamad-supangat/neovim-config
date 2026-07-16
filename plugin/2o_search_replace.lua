vim.g.maplocalleader = ','

require('grug-far').setup({
  transient = true,
  prefills = {
    search = '',
    flags = '--multiline',
  },
  -- engine = 'ripgrep' is default, but 'astgrep' can be specified
})

local keymap = vim.keymap.set
-- Find and replace (Spectre/grug-far)
keymap('n', '<leader>S', function()
  require('grug-far').open({ transient = true })
end, { desc = 'Toggle Spectre' })

keymap({ 'n', 'v' }, '<leader>sw', function()
  require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
end, { desc = 'Search current word' })

keymap('n', '<leader>sp', function()
  require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
end, { desc = 'Search on current file' })

keymap('n', '<leader>sf', function()
  local currentFilePath = vim.api.nvim_buf_get_name(0)
  local currentFileDirectory = currentFilePath:match('(.*/)') or ''
  require('grug-far').open({ prefills = { paths = currentFileDirectory } })
end, { desc = 'Toggle Spectre Current Folder' })
