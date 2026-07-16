--- di ambil dari
-- https://github.com/gbrlsnchs/winpick.nvim/blob/trunk/lua/winpick.lua

local utils = require("utils")

local api = vim.api

local ESC_CODE = 27

--- Shows label and buffer name, if available. Else, show only the label.
---@param label string : Label to be shown alongside the buffer name.
---@param _     number : ID of the selected window.
---@param bufnr number : ID of the selected window's buffer.
---@return string: The label as is.
local function default_label_formatter(label, _, bufnr)
  return label
  -- local buf_name = api.nvim_buf_get_name(bufnr)

  -- if buf_name:len() == 0 then
  --   return label
  -- end
  -- return string.format("%s: %s", label, vim.fn.fnamemodify(buf_name, ":~:."))
end

local function default_filter_window(winid, bufnr)
  -- 1. Cek buftype: file normal memiliki buftype kosong ("")
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
  if buftype ~= "" then
    return false
  end

  -- 2. Cek nama buffer: file asli pasti memiliki path/nama
  local name = vim.api.nvim_buf_get_name(bufnr)
  -- if name == "" then return false end

  -- 3. Filter eksplisit berdasarkan filetype (opsional, untuk keamanan ekstra)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local excluded_ft = {
    terminal = true,
    ["mini.files"] = true,
    cmdwin = true,
    msg = true,
    message = true,
    help = true,
    qf = true,
    prompt = true
  }
  if excluded_ft[filetype] then
    return false
  end

  return true
end

local defaults = {
  border = "double",
  filter = default_filter_window,
  prompt = "Pick a window: ",
  format_label = default_label_formatter,
  chars = nil
}

local M = {}

--- Prompts for a window to be selected. A callback is used for handling the action. The default
--- action is to focus the selected window. The argument passed to the callback is a window ID if a
--- window is selected or nil if it the selection is aborted.
---@param opts table | nil: Optional options that may override global options.
---@return number | nil, number | nil: Selected window table containing ID and its corresponding buffer ID.
function M.select(opts)
  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  local wins = api.nvim_tabpage_list_wins(0)
  wins = vim.tbl_map(function (winid)
    return { id = winid, bufnr = api.nvim_win_get_buf(winid) }
  end, wins)

  -- Filter out some buffers according to configuration.
  local eligible_wins = vim.tbl_filter(function (win)
    if opts.filter then
      return opts.filter(win.id, win.bufnr)
    end

    return true
  end, wins)

  if #eligible_wins == 0 then
    eligible_wins = wins
  end

  if #eligible_wins == 1 then
    local win = eligible_wins[1]
    return win.id, win.bufnr
  end

  local targets = {}
  local chars = utils.resolve_chars(opts.chars or {})
  local total_chars = #chars

  if #eligible_wins > total_chars then
    vim.notify(
      "[winpick.nvim] The number of eligible windows is greater than the number of label characters, some windows will never be picked",
      vim.log.levels.WARN
    )
  end

  for idx, win in ipairs(eligible_wins) do
    local next_char = chars[idx % (total_chars + 1)]
    targets[next_char] = win
  end

  local cues = utils.show_cues(targets, opts)

  vim.cmd("mode") -- clear cmdline once
  print(opts.prompt or defaults.prompt)

  local ok, choice = pcall(vim.fn.getchar) -- Ctrl-C returns an error

  vim.cmd("mode") -- clear cmdline again to remove pick-up message
  utils.hide_cues(cues)

  local is_ctrl_c = not ok
  local is_esc = choice == ESC_CODE

  if is_ctrl_c or is_esc then
    return nil, nil
  end

  choice = string.char(choice):upper()

  local win = targets[choice]

  if win then
    return win.id, win.bufnr
  end

  return nil, nil
end

--- Sets up the plug-in by overriding default options.
---@param opts table: Options to be globally overridden.
function M.setup(opts)
  defaults = vim.tbl_deep_extend("force", defaults, opts or {})
end

--- Default values, for reusability. Read-only, errors if modified.
M.defaults = setmetatable({}, {
  __index = defaults,
  __newindex = function ()
    error("defaults are read-only")
  end
})

return M
