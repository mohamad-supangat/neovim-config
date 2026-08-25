-- vim.cmd('colorscheme minispring')

local keymap = vim.keymap.set

require('mini.basics').setup({
  options = { basic = false },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = true,
  },
  mappings = {
    basic = true,
    extra_ui = true,
    win_borders = 'rounded',
    windows = true,
    move_with_alt = true,
  },
})

require('mini.bufremove').setup()
require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
-- require('mini.notify').setup()
require('mini.tabline').setup()
require('mini.files').setup({
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
    go_in = 'L',
    go_in_plus = 'l',
    go_out = 'H',
    go_out_plus = 'h',
  },
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    local open_in_window_picker = function()
      local fs_entry = MiniFiles.get_fs_entry()
      if fs_entry ~= nil and fs_entry.fs_type == 'file' then
        local picked_window_id = require('winpick').select()
        if picked_window_id ~= nil then
          MiniFiles.set_target_window(picked_window_id)
        end
      end
      MiniFiles.go_in({
        close_on_file = true,
      })
    end
    keymap('n', 'l', open_in_window_picker, { buffer = buf_id, desc = 'Open in target window' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesWindowUpdate',
  callback = function(args)
    local win_id = args.data.win_id
    -- Ensure window exists before updating config
    if vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_win_set_config(win_id, {
        border = 'rounded',
      })
    end
  end,
})

require('mini.misc').setup()
require('mini.extra').setup()
require('mini.diff').setup()
require('mini.git').setup()
-- require('mini.indentscope').setup({
--   symbol = '▏',
--   options = {
--     try_as_border = true,
--   },
--   -- draw = {
--   --   delay = 0,
--   --   animation = require("mini.indentscope").gen_animation.none(),
--   -- },
-- })

require('mini.pairs').setup({ modes = { command = true } })

require('mini.pick').setup({
  window = {
    config = function()
      height = math.floor(0.618 * vim.o.lines)
      width = math.floor(0.618 * vim.o.columns)
      return {
        border = 'rounded',
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end,
  },
  mappings = {
    delete_word = '<A-BS>',
    move_down = '<C-j>',
    move_up = '<C-k>',
  },
})

require('mini.surround').setup()
require('mini.splitjoin').setup()
require('mini.trailspace').setup()

local function get_macro_status()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  end
  return '󰑊 Recording @' .. recording_register
end
require('mini.statusline').setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 75 })
      local diag = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 50 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location = MiniStatusline.section_location({ trunc_width = 75 })
      local macro = get_macro_status()

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineModeReplace', strings = { macro } },

        {
          hl = 'MiniStatuslineDevinfo',
          strings = {
            -- git,
            diag,
          },
        },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=',
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        -- { hl = mode_hl, strings = { location } },
      })
    end,
  },
})

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },
    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },
    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    -- Window commands
    { mode = 'n', keys = '<C-w>' },
    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})
-- keymap

keymap('n', '<C-p>', '<Cmd>Pick files<Cr>', { desc = 'Pick Files' })
keymap('n', '<c-n>', function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
  end
end, { desc = 'Open file picker' })
keymap('n', '<Leader>ep', function()
  MiniPick.builtin.files({}, {
    source = {
      name = 'Neovim Config',
      cwd = vim.fn.stdpath('config'),
    },
  })
end, { desc = 'Select Neovim config file' })
-- keymap('n', '<c-z>', '<Cmd>lua MiniMisc.zoom()<CR>', { desc = 'Zoom toggle / Zen Mode' })
keymap('n', '<Leader>nn', '<Cmd>lua MiniNotify.show_history()<CR>', { desc = 'Notifications' })
keymap('n', '<Leader>fb', '<Cmd>Pick buffers<CR>', { desc = 'Pick Buffers' })
