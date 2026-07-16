vim.bo.commentstring = "{{-- %s --}}"

vim.api.nvim_create_user_command(
  "Format",
  function ()
    require("conform").format({ lsp_fallback = false })
    vim.lsp.buf.format({ async = false })
  end,
  {
    desc = "Format blade terlebih dahulu baru dengan lsp"
  }
)
