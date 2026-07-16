local keymap = vim.keymap.set

keymap({ 'i', 't', 'v', 'c' }, '<A-BS>', '<C-W>', { desc = 'delete word' })

keymap('v', '<BS>', '"_d', { desc = 'Delete without cut /copy to buffer clipboard' })

keymap('n', '<leader>-', '<C-w>s', { desc = 'Split window horizontal' })

keymap('n', '<leader>|', '<C-w>v<C-w>l', { desc = 'Split window vertical' })

keymap('v', '/', '"fy/\\V<C-R>f<CR>', { desc = 'Search current tag' })

keymap('n', '<leader>cf', function()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath)
  vim.notify('Copied full path: ' .. filepath, vim.log.levels.INFO, { title = 'Clipboard' })
end, { desc = 'Copy File Path to clipboard' })

keymap('n', '<leader>cF', function()
  local filepath = vim.fn.expand('%:p')
  vim.fn.setreg('+', filepath)
  vim.notify('Copied full path: ' .. filepath, vim.log.levels.INFO, { title = 'Clipboard' })
end, { desc = 'Copy Full File Path to clipboard' })

keymap('n', '<Leader>uu', '<Cmd>Pack<CR>', { desc = 'Update Plugins' })

keymap('n', '<Leader>q', ':q<CR>', { desc = 'Exit neovim' })

keymap('n', '<Leader>qa', ':quitall!<CR>', { desc = 'Force Exit' })

keymap('n', '<leader>rs', '<cmd>restart<cr>', { desc = 'Restart Neovim' })

keymap('n', '<Leader>ep', function()
  MiniPick.builtin.files({}, {
    source = {
      name = 'Neovim Config',
      cwd = vim.fn.stdpath('config'),
    },
  })
end, { desc = 'Select Neovim config file' })

keymap('n', '<leader>gp', function()
  vim.notify('Pulling git repo...', vim.log.levels.INFO, { title = 'Git' })
  vim.cmd('Git pull')
  vim.notify('Pulling done.', vim.log.levels.INFO, { title = 'Git' })
end, { desc = 'Git: Pull' })

-- Git auto commit
keymap('n', '<leader>gc', require('utils').GitAutoCommit, { desc = 'Git: Auto commit dan push' })

keymap('n', '<C-t>', '<Cmd>enew<CR>', { desc = 'New Buffer' })

keymap('n', '<Leader>ba', '<Cmd>b#<CR>', { desc = 'Alternate' })

keymap('n', '<Leader>bd', '<Cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete' })

keymap('n', '<Leader>bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', { desc = 'Delete!' })

keymap('n', '<Leader>bn', '<Cmd>bnext<CR>', { desc = 'Buffer Next' })
keymap('n', '<Leader>bb', '<Cmd>bprev<CR>', { desc = 'Buffer Prev' })

keymap('n', '<leader>sm', function()
  vim.cmd('!sublime_merge ' .. require('utils').currentFileRootPath() .. '&')
end, { desc = 'Buka Sublime Merge' })

keymap('n', '<leader>na', function()
  vim.cmd('!nautilus ' .. require('utils').currentFileRootPath() .. '&')
end, { desc = 'Buka File Manager nautilus' })

keymap('n', '<leader>cd', ':cd %:p:h<CR>', { desc = 'Change dir to current opened file' })

keymap('n', '<C-a>', '<Esc>ggVG', { desc = 'Select All Text in current file' })

keymap('v', '<Tab>', '>gv', { noremap = true, silent = true, desc = 'Indent >' })
keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true, desc = 'Indent <' })
keymap('v', '>', '>gv', { noremap = true, silent = true, desc = 'Indent >' })
keymap('v', '<', '<gv', { noremap = true, silent = true, desc = 'Indent <' })
