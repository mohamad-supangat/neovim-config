-- ┌─────────────────────────┐
-- │ Filetype config example │
-- └─────────────────────────┘
--
-- This is an example of a configuration that will apply only to a particular
-- filetype, which is the same as file's basename ('markdown' in this example;
-- which is for '*.md' files).
--
-- It can contain any code which will be usually executed when the file is opened
-- (strictly speaking, on every 'filetype' option value change to target value).
-- Usually it needs to define buffer/window local options and variables.
-- So instead of `vim.o` to set options, use `vim.bo` for buffer-local options and
-- `vim.cmd('setlocal ...')` for window-local options (currently more robust).
--
-- This is also a good place to set buffer-local 'mini.nvim' variables.
-- See `:h mini.nvim-buffer-local-config` and `:h mini.nvim-disabling-recipes`.

-- Enable spelling and wrap for window
vim.cmd("setlocal spell wrap")

-- Fold with tree-sitter
vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()")

-- Disable built-in `gO` mapping in favor of 'mini.basics'
vim.keymap.del("n", "gO", { buffer = 0 })

-- Set markdown-specific surrounding in 'mini.surround'
vim.b.minisurround_config = {
	custom_surroundings = {
		-- Markdown link. Common usage:
		-- `saiwL` + [type/paste link] + <CR> - add link
		-- `sdL` - delete link
		-- `srLL` + [type/paste link] + <CR> - replace link
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
		stripped_line = string.gsub(stripped_line, "^%d+%.%s+", "") -- Hapus list bernomor (1., 2., dst)

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
