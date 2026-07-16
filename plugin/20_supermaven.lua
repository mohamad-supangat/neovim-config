vim.pack.add({
  "https://github.com/supermaven-inc/supermaven-nvim"
})

require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<C-y>",
    clear_suggestion = "<C-backspace>",
    accept_word = "<leader>y",
  },
  -- ignore_filetypes = { cpp = true }, -- or { "cpp", }
  -- color = {
  --   suggestion_color = "#ffffff",
  --   cterm = 244,
  -- },
  log_level = "info",
  disable_inline_completion = false,
  disable_keymaps = false,
  -- condition = function()
  --   return false
  -- end,
})
