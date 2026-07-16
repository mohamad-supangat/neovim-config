vim.cmd('colorscheme miniwinter')

local keymap = vim.keymap.set

require("mini.basics").setup({
  options = { basic = false },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = true,
  },
  mappings = {
    basic = true,
    extra_ui = true,
    win_borders = "single",
    windows = true,
    move_with_alt = true,
  },
})

require("mini.bufremove").setup()
require("mini.icons").setup()
require('mini.icons').mock_nvim_web_devicons()
require("mini.notify").setup()
require("mini.tabline").setup()

require("mini.files").setup({
  use_as_default_explorer = true,
  content = {
    filter = function(fs_entry)
      return true
    end,
    -- prefix = function() end, -- disable icon in mini.files,
  },
  width_focus = 30,
  width_nofocus = 20,
  width_preview = 25,
  mappings = {
    go_in = "L",
    go_in_plus = "l",
    go_out = "H",
    go_out_plus = "h",
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    local open_in_window_picker = function()
      local fs_entry = MiniFiles.get_fs_entry()
      if fs_entry ~= nil and fs_entry.fs_type == "file" then
        local picked_window_id = require("winpick").select()
        if picked_window_id ~= nil then
          MiniFiles.set_target_window(picked_window_id)
        end
      end
      MiniFiles.go_in({
        close_on_file = true,
      })
    end
    keymap("n", "l", open_in_window_picker, { buffer = buf_id, desc = "Open in target window" })
  end,
})


require("mini.misc").setup()
require("mini.extra").setup()
require("mini.diff").setup()
require("mini.git").setup()
require("mini.indentscope").setup({
  symbol = "▏",
  options = {
    try_as_border = true,
  },
  -- draw = {
  --   delay = 0,
  --   animation = require("mini.indentscope").gen_animation.none(),
  -- },
})

require("mini.pairs").setup({ modes = { command = true } })



require("mini.pick").setup({
  window = {
    config = function()
      height = math.floor(0.618 * vim.o.lines)
      width = math.floor(0.618 * vim.o.columns)
      return {
        border = "single",
        anchor = "NW",
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end,
  },
  mappings = {
    delete_word = "<A-BS>",
    move_down = "<C-j>",
    move_up = "<C-k>",
  },
})


require("mini.surround").setup()
require("mini.splitjoin").setup()
require("mini.trailspace").setup()




-- keymap
keymap("n", "<C-p>", function()
  require("mini.pick").builtin.cli({
    command = {
      "rg",
      "--files",
      "--hidden",
      "-uu",
      "-g",
      "!/**/.git",
      "-g",
      "!/**/node_modules",
      "-g",
      "!/vendor",
      "-g",
      "!/public/build",
      "-g",
      "!*.{jpg,jpeg,png,gif,bmp,tiff,mov,mp4,avi,mpeg,webm,pdf,doc,docx,mp3,cache,gitkeep,gitignore}",
    },
  })
end, { desc = "Pick Files" })
keymap("n", "<c-n>", function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
  end
end, { desc = "Open file picker" })



keymap("n", "<Leader>ep", function()
  MiniPick.builtin.files({}, {
    source = {
      name = "Neovim Config",
      cwd = vim.fn.stdpath("config"),
    },
  })
end, { desc = "Select Neovim config file" })


keymap(
  "n",
  "<c-z>",
  "<Cmd>lua MiniMisc.zoom()<CR>",
  { desc = "Zoom toggle / Zen Mode" }
)

vim.keymap.set(
  "n",
  "<Leader>nn",
  "<Cmd>lua MiniNotify.show_history()<CR>",
  { desc = "Notifications" }
)
