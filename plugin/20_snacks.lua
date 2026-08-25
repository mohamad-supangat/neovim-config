require('snacks').setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  indent = {
    enabled = true,
    scope = {
      enabled = true,
    },
    chunk = {
      enabled = true,
    },
  },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
  image = {
    enabled = true,
    inline = false,
    doc = {
      inline = false,
    },
  },
})

local keymap = vim.keymap.set

keymap('n', '<c-z>', '<Cmd>lua Snacks.zen.zoom()<CR>', { desc = 'Zoom toggle / Zen Mode' })
