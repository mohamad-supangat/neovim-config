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
  notifier = {
    backdrop = true,
    enabled = true,
    timeout = 3000,
    top_down = false,
    style = 'minimal',
  },
})

vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev { data: { client_id: integer, params: lsp.ProgressParams } }
  callback = function(ev)
    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(vim.lsp.status(), 'info', {
      id = 'lsp_progress',
      title = 'LSP Progress',
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == 'end' and ' '
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

local keymap = vim.keymap.set

keymap('n', '<c-z>', '<Cmd>lua Snacks.zen.zoom()<CR>', { desc = 'Zoom toggle / Zen Mode' })
keymap('n', '<leader>nn', '<Cmd>lua Snacks.notifier.show_history()<CR>', { desc = 'Zoom toggle / Zen Mode' })
