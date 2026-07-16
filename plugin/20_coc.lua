if package.loaded['coc.nvimm'] then
  vim.g.coc_global_extensions = {
    'coc-json',
    'coc-marketplace',
    'coc-snippets',
    'coc-lua',
    -- "coc-explorer",
    -- "coc-pairs",
    'coc-emmet',
    'coc-prettier',
  }

  local keymap = vim.keymap.set

  -- coc multiple cursor
  keymap('n', '<leader>c', '<Plug>(coc-cursors-position)')
  keymap('n', '<leader>d', '<Plug>(coc-cursors-word)')
  keymap('x', '<leader>d', '<Plug>(coc-cursors-range)')
  keymap('n', '<leader>x', '<Plug>(coc-cursors-operator)')

  -- coc-explorer
  -- keymap("n", "<C-n>", ":CocCommand explorer<CR>")

  keymap('n', '<leader>ca', '<Plug>(coc-codeaction)')
  -- keymap("n", "<leader>l", ":CocCommand eslint.executeAutofix<CR>")
  keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
  keymap('n', 'K', ":call CocActionAsync('doHover')<CR>", { silent = true, noremap = true })
  keymap('n', '<leader>rn', '<Plug>(coc-rename)')

  -- snippets
  -- keymap("i", "<leader>s", "<Plug>(coc-snippets-expand)")
  keymap('x', '<leader>x', '<Plug>(coc-convert-snippet)')
  -- keymap("v", "<leader>ss", "<Plug>(coc-snippets-select)")
  keymap('v', '<leader>ss', '<Plug>(coc-snippets-select)')

  -- formatter command
  keymap('n', '<leader>fm', ":call CocActionAsync('format')<CR>")
  keymap('x', '<leader>fm', '<Plug>(coc-format-selected)<CR>')
  keymap('v', '<leader>fm', '<Plug>(coc-format-selected)<CR>')

  -- diagnostic
  keymap('n', '[g', '<Plug>(coc-diagnostic-prev)')
  keymap('n', ']g', '<Plug>(coc-diagnostic-next)')
  keymap('n', '<leader>xx', '<cmd>CocDiagnostics<cr>')
  keymap('n', 'gl', ":call CocActionAsync('diagnosticInfo')<CR>")

  -- show list in fzf / coc
  keymap('n', '<leader>coc', ':CocList<CR>')
  keymap('n', '<leader>P', ':CocList commands<CR>')

  -- Completion & PUM (Popup Menu) Keybindings
  keymap('i', '<C-space>', 'coc#refresh()', { silent = true, expr = true })
  keymap('i', '<TAB>', "coc#pum#visible() ? coc#pum#next(1) : '<TAB>'", { noremap = true, silent = true, expr = true })

  keymap(
    'i',
    '<S-TAB>',
    "coc#pum#visible() ? coc#pum#prev(1) : '<C-h>'",
    { noremap = true, silent = true, expr = true }
  )

  keymap('i', '<C-j>', "coc#pum#visible() ? coc#pum#next(1) : '<C-j>'", { noremap = true, silent = true, expr = true })
  keymap('i', '<C-k>', "coc#pum#visible() ? coc#pum#prev(1) : '<C-k>'", { noremap = true, silent = true, expr = true })

  -- keymap("i", "<down>", "coc#pum#visible() ? coc#pum#next(1) : '<down>'", { noremap=true, silent = true, expr = true })
  -- keymap("i", "<up>", "coc#pum#visible() ? coc#pum#prev(1) : '<up>'", { noremap=true, silent = true, expr = true })

  keymap(
    'i',
    '<CR>',
    "coc#pum#visible() ? coc#pum#confirm() : '<C-G>u<CR><C-R>=coc#on_enter()<CR>'",
    { silent = true, expr = true, noremap = true }
  )

  keymap('n', '<f7>', '<cmd>CocOutline<cr>')
end
