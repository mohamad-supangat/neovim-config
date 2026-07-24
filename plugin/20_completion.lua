vim.o.pumblend = 5

require('mini.cmdline').setup()
require('mini.completion').setup({
  window = {
    info = { height = 30, width = 80, border = 'rounded' },
    signature = { height = 30, width = 80, border = 'rounded' },
  },
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = true,
    -- process_items = process_items,
  },
})

local on_attach = function(ev)
  vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
end
Config.new_autocmd('LspAttach', nil, on_attach, "Set 'omnifunc'")

local map_multistep = require('mini.keymap').map_multistep

map_multistep('i', '<Tab>', { 'pmenu_next' })
map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
map_multistep('i', '<BS>', { 'minipairs_bs' })
