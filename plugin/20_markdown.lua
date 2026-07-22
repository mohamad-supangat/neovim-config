require('touchup').setup({
  bullets = { enabled = true, icons = { '✸', '✿', '✦', '✧' } },
  checkboxes = { enabled = true },
  code_blocks = { enabled = true },
  markers = { enabled = true },
  quotes = { enabled = true },
  enter = { enabled = true },
})

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
