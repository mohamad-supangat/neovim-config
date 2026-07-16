require('render-markdown').setup({
  render_modes = true,
  anti_conceal = { enabled = true },
  completions = { lsp = { enabled = true } },
  heading = { position = 'inline' },
  checkbox = {
    render_modes = true,
    bullet = false,
    -- left_pad = 0,
    -- right_pad = 1,
    unchecked = {
      icon = '󰄱 ',
      highlight = 'RenderMarkdownUnchecked',
      scope_highlight = nil,
    },
    checked = {
      -- icon = "󰱒 ",
      icon = '󰄲 ',
      highlight = 'RenderMarkdownChecked',
      scope_highlight = nil,
    },
    custom = {
      todo = {
        raw = '[-]',
        rendered = '󰥔 ',
        highlight = 'RenderMarkdownTodo',
        scope_highlight = nil,
      },
    },
    scope_priority = nil,
  },
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
