local customSnippetPath = vim.fn.stdpath('config') .. '/after/snippets'

-- require("scissors").setup({
--   snippetDir = customSnippetPath
-- })
--
-- -- Nvim scissors mappings
-- vim.keymap.set("n", "<leader>sne", function ()
--   require("scissors").editSnippet()
-- end, { noremap = true, silent = true, desc = "Edit snippet" }
-- )
--
-- vim.keymap.set({ "n", "x" }, "<leader>sna", function ()
--   require("scissors").addNewSnippet()
-- end, { noremap = true, silent = true, desc = "Add new snippet" }
-- )
--

require('mini.snippets').setup({
  snippets = {
    { prefix = 'cdate', body = '$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE' },
    { prefix = 'today', body = '$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE' },
    require('mini.snippets').gen_loader.from_lang(),
  },
  mappings = {
    expand = '<C-A-Space>',
    jump_next = '<C-l>',
    jump_prev = '<C-h>',
    stop = '<C-c>',
  },

  expand = {
    prepare = function(raw_snippets)
      local _, cont = MiniSnippets.default_prepare({})
      cont.cursor = vim.api.nvim_win_get_cursor(0)
      return MiniSnippets.default_prepare(raw_snippets, { context = cont })
    end,
    match = function(snippets)
      return snippets
      -- return MiniSnippets.default_match(snippets, { pattern_fuzzy = "%w*" })
    end,
    -- select = function(snippets, insert) return insert(snippets[1]) end,
    insert = function(snippet, _)
      return MiniSnippets.default_insert(snippet, {
        empty_tabstop = '',
        empty_tabstop_final = '',
        -- empty_tabstop = "•",
        -- empty_tabstop_final = "∎",

        normalize = false,
        -- lookup = {
        --   TM_SELECTED_TEXT = table.concat(vim.fn.getreg("a", true, true), "\n"),
        -- },
      })
    end,
  },
})

require('mini.snippets').start_lsp_server({
  match = false,
})

-- disbale underline in current cursor
-- i not exited with this
-- Daftar highlight group yang ingin dihapus
local groups = {
  'MiniSnippetsCurrent',
  'MiniSnippetsVisited',
  'MiniSnippetsUnvisited',
  'MiniSnippetsCurrentReplace',
  'MiniSnippetsFinal',
}

-- Loop untuk clear semuanya
for _, group in ipairs(groups) do
  vim.api.nvim_set_hl(0, group, {})
end
