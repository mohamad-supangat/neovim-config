vim.api.nvim_create_user_command('ShowHighlights', function()
  local hl_groups = vim.fn.getcompletion('', 'highlight')
  local buf = vim.api.nvim_create_buf(false, true)

  -- Isi buffer dengan daftar highlight
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, hl_groups)

  -- Atur opsi buffer agar menjadi scratch buffer (tidak disimpan ke file)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })

  -- Buka di jendela split baru
  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, buf)
end, {})
