vim.pack.add({
  'https://github.com/ingur/floatty.nvim'
})

local term = require("floatty").setup({})
local keymap = vim.keymap.set

keymap("n", "<A-i>", function()
  term.toggle()
end)
keymap("t", "<A-i>", function()
  term.toggle()
end)

local term1 = require("floatty").setup({
  window = {
    width = 0.4,
    h_align = "left",
    v_align = "bottom",
  },
})
keymap("n", "<f1>", function()
  term1.toggle()
end)
keymap("t", "<f1>", function()
  term1.toggle()
end)

local term2 = require("floatty").setup({
  window = {
    width = 0.4,
    h_align = "right",
    v_align = "bottom",
  },
})
keymap("n", "<f2>", function()
  term2.toggle()
end)
keymap("t", "<f2>", function()
  term2.toggle()
end)

function _G.lazygit()
  local lazygit = require("floatty").setup({
    cmd = "lazygit -p " .. require("utils").currentFileRootPath(),
    window = {
      width = 1,
      height = 1,
    },
  })
  lazygit.toggle()
end

function _G.lazydocker()
  local lazygit = require("floatty").setup({
    cmd = "lazydocker",
    window = {
      width = 1,
      height = 1,
    },
  })
  lazygit.toggle()
end

keymap("n", "<Leader>gi", ":lua lazygit()<CR>")
keymap("n", "<Leader>do", ":lua lazydocker()<CR>")
