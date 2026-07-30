local customSnippetPath = vim.fn.stdpath('config') .. '/snippets'

local keymap = vim.keymap.set
-- -- Nvim scissors mappings
keymap('n', '<leader>sne', function()
  require('scissors').editSnippet()
end, { desc = 'Edit snippet' })

keymap({ 'n', 'x' }, '<leader>sna', function()
  require('scissors').addNewSnippet()
end, { desc = 'Add new snippet' })
