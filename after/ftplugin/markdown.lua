vim.cmd("setlocal spell wrap")

vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()")

vim.keymap.del("n", "gO", { buffer = 0 })

vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { "%[().-()%]%(.-%)" },
      output = function()
        local link = require("mini.surround").user_input("Link: ")
        return { left = "[", right = "](" .. link .. ")" }
      end,
    },
  },
}
local function toggle_checkbox_or_enter()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1]
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]

  local checkbox_options = {
    [" "] = "x",
    ["x"] = " ",
  }

  -- 1. Cek apakah baris sudah memiliki checkbox
  local start_idx, end_idx, spaces, bullet, status = string.find(line, "^(%s*)([%-%*]?)%s*%[(.)%]")

  if start_idx then
    -- JIKA ADA: Jalankan fungsi toggle status
    local next_status = checkbox_options[status] or " "
    local new_line = string.sub(line, 1, start_idx - 1)
        .. spaces
        .. bullet
        .. (bullet ~= "" and " " or "")
        .. "["
        .. next_status
        .. "]"
        .. string.sub(line, end_idx + 1)

    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { new_line })
  else
    -- JIKA TIDAK ADA: Tambahkan - [ ] di depan baris tersebut
    local indent = string.match(line, "^%s*") or ""
    local stripped_line = string.gsub(line, "^%s*", "")

    -- PERBAIKAN: Hapus bullet/list marker yang sudah ada (seperti -, *, +, atau angka 1.)
    -- agar tidak terjadi duplikasi seperti "- [ ] - Import Barang Masuk"
    stripped_line = string.gsub(stripped_line, "^[%-%*%+]%s+", "") -- Hapus -, *, atau +
    stripped_line = string.gsub(stripped_line, "^%d+%.%s+", "")  -- Hapus list bernomor (1., 2., dst)

    -- Susun baris baru dengan format checkbox
    local new_line = indent .. "- [ ] " .. stripped_line
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { new_line })

    -- Sesuaikan posisi kursor agar maju mengikuti penambahan karakter "- [ ] "
    vim.api.nvim_win_set_cursor(0, { lnum, cursor[2] + 6 })
  end
end

-- REGISTER KEYMAP (Hanya untuk Filetype Markdown)
vim.keymap.set("n", "<CR>", toggle_checkbox_or_enter, {
  buffer = true,
  desc = "Toggle or Create Markdown Checkbox",
})
