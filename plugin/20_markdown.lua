local obsidianPath = vim.fn.expand('~/Documents/Obsidian/')
vim.keymap.set(
  'n',
  '<leader>no',
  '<cmd>edit ' .. obsidianPath .. '<CR>:lcd %:p:h<CR>',
  { noremap = true, silent = true, desc = 'Obsidian notes picker' }
)

vim.keymap.set('n', '<Leader>nk', function()
  MiniPick.builtin.files({}, {
    source = {
      name = 'Notes',
      cwd = obsidianPath,
    },
  })
end, { noremap = true, silent = true, desc = 'Obsidian notes picker' })
