require('smart-splits').setup({})

local keymap = vim.keymap.set

-- Smart splits mappings
keymap('n', '<A-h>', require('smart-splits').resize_left, { desc = 'Resize left' })
keymap('n', '<A-j>', require('smart-splits').resize_down, { desc = 'Resize down' })
keymap('n', '<A-k>', require('smart-splits').resize_up, { desc = 'Resize up' })
keymap('n', '<A-l>', require('smart-splits').resize_right, { desc = 'Resize right' })
keymap('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = 'Move cursor left' })
keymap('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = 'Move cursor down' })
keymap('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = 'Move cursor up' })
keymap('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = 'Move cursor right' })
keymap('n', '<C-\\>', require('smart-splits').move_cursor_previous, { desc = 'Move cursor previous' })
keymap('n', '<leader><leader>h', require('smart-splits').swap_buf_left, { desc = 'Swap buffer left' })
keymap('n', '<leader><leader>j', require('smart-splits').swap_buf_down, { desc = 'Swap buffer down' })
keymap('n', '<leader><leader>k', require('smart-splits').swap_buf_up, { desc = 'Swap buffer up' })
keymap('n', '<leader><leader>l', require('smart-splits').swap_buf_right, { desc = 'Swap buffer right' })
