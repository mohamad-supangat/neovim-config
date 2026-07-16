vim.g.maplocalleader = ","

require("grug-far").setup({
  transient = true,
  prefills = {
    search = "",
    flags = "--multiline",
  },
  -- engine = 'ripgrep' is default, but 'astgrep' can be specified
})

-- Find and replace (Spectre/grug-far)
vim.keymap.set("n", "<leader>S", function()
  require("grug-far").open({ transient = true })
end, { noremap = true, silent = true, desc = "Toggle Spectre" })

vim.keymap.set({ "n", "v" }, "<leader>sw", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { noremap = true, silent = true, desc = "Search current word" })

vim.keymap.set("n", "<leader>sp", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { noremap = true, silent = true, desc = "Search on current file" })

vim.keymap.set("n", "<leader>sf", function()
  local currentFilePath = vim.api.nvim_buf_get_name(0)
  local currentFileDirectory = currentFilePath:match("(.*/)") or ""
  require("grug-far").open({ prefills = { paths = currentFileDirectory } })
end, { noremap = true, silent = true, desc = "Toggle Spectre Current Folder" })


