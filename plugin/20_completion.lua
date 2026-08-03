local cmp = require('blink.cmp')
-- cmp.build():pwait()
cmp.setup({
  sources = { default = { 'snippets', 'lsp', 'path', 'buffer' } },
  fuzzy = {
    implementation = 'lua',
    sorts = { 'score' },
  },
  completion = {
    keyword = { range = 'full' },
    accept = { auto_brackets = { enabled = false } },
    list = { selection = { preselect = true, auto_insert = false } },
    menu = {
      border = 'none',
      auto_show = true,
      draw = {
        gap = 2,
        columns = {
          { 'kind_icon', gap = 1 },
          { 'label', 'label_description', gap = 1 },
          { 'source_name', gap = 1 },
        },
        components = {
          source_name = {
            highlight = 'BlinkCmpKind',
          },
        },
        treesitter = { 'lsp' },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = 'none',
      },
    },
    trigger = {
      prefetch_on_insert = false,
      show_on_trigger_character = false,
      show_on_insert_on_trigger_character = false,
      show_on_accept_on_trigger_character = false,
    },
    ghost_text = { enabled = false },
  },
  signature = { enabled = true, window = { border = 'none' } },
  keymap = {
    preset = 'none',
    ['<CR>'] = { 'accept', 'fallback' },
    ['<C-A-space>'] = {
      function(_cmp)
        _cmp.show({ providers = { 'snippets' } })
      end,
    },
    ['<C-space>'] = { 'show', 'hide' },
    ['<C-S-k>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
    ['<C-e>'] = { 'hide', 'fallback' },

    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'snippet_forward', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    -- ["<C-l>"] = { "accept", "fallback" },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  },
})
