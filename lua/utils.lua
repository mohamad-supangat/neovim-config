local api = vim.api

local alphabet = {}
for byte = string.byte("A"), string.byte("Z") do
  table.insert(alphabet, string.char(byte))
end

for byte = string.byte("0"), string.byte("9") do
  table.insert(alphabet, string.char(byte))
end

local M = {}

function M.get_root(cwd)
  local status, job = pcall(require, "plenary.job")
  if not status then
    return fn.system("git rev-parse --show-toplevel")
  end

  local gitroot_job = job:new({
    "git",
    "rev-parse",
    "--show-toplevel",
    cwd = cwd,
  })

  local path, code = gitroot_job:sync()
  if code ~= 0 then
    return nil
  end

  return table.concat(path, "")
end

function M.currentFileRootPath()
  local current_dir = vim.fn.expand("%:p:h")
  local git_root = M.get_root(current_dir)
  return git_root
end

function M.GitAutoCommit(message)
  -- Helper function to perform common git operations
  local function perform_git_operations(commit_msg)
    vim.cmd("Git add .")
    vim.cmd(string.format("Git commit -m %s", commit_msg:gsub(" ", "\\ ")))
    vim.cmd("Git push")

    vim.notify("Git auto commit dan push selesai.", vim.log.levels.INFO, { title = "Git Auto Commit" })
  end

  if message == nil or message == "" then
    -- If no message is provided, prompt the user asynchronously using vim.ui.input
    vim.ui.input({
      prompt = "Masukkan pesan commit (kosong untuk pesan default): ",
      -- Optional: 'completion' can be 'file', 'dir', or 'shell'
      -- completion = "file",
    }, function(user_input)
      local commit_message_final
      -- Check if user provided input (not nil for cancel, not empty string for blank input)
      if user_input ~= nil and user_input ~= "" then
        vim.notify_once(user_input, vim.log.levels.INFO, { title = "Pesan Commit yang dikirimkan" })
        -- Use user's input if provided
        commit_message_final = user_input
        perform_git_operations(commit_message_final)
      else
        -- Generate default message if user input is empty or cancelled
        local current_datetime = os.date("%Y-%m-%d %H:%M:%S")
        commit_message_final = "auto commit from neovim: " .. current_datetime
      end
      -- Perform git operations with the determined message
    end)
  else
    -- If a message is provided, proceed directly with git operations
    perform_git_operations(message)
  end
end

function M.is_huawei_host()
  local hostname_file = "/etc/hostname"
  local f = io.open(hostname_file, "r")

  if not f then
    -- Gagal membuka file, anggap bukan 'huawei'
    -- Ini bisa terjadi jika file tidak ada atau ada masalah izin.
    return false
  end

  local hostname = f:read("*l") -- Baca baris pertama
  f:close()

  if not hostname then
    return false -- Gagal membaca konten
  end

  -- Hapus whitespace (terutama newline) dari akhir string
  hostname = hostname:gsub("%s+", "")

  return hostname == "huawei"
end

--- Beberapa helpes dari winpick
-- Description.
-- @param name type Parameter description.
-- @return type  Description of the returned object.
-- @usage Example about how to use it.

--- Maps a table index to an ASCII character starting from A (1 is A, 2 is B, and so on).
--- @param idx integer: Index of a table.
--- @return string: The respective ASCII character.
function M.format_index(idx)
  return string.char(idx + 64)
end

--- Returns the list of labels that will sequentially be used for visual cues.
--- @param custom_chars table: List of characters that will serve as labels.
--- @return table: Alphabet containing user-provided characters plus a complementary alphabet.
function M.resolve_chars(custom_chars)
  if vim.tbl_isempty(custom_chars) then
    return alphabet
  end

  local chars = {}
  local added = {}

  for _, charlist in ipairs({ custom_chars, alphabet }) do
    for _, char in ipairs(charlist) do
      local val = char:upper()

      if not added[val] then
        added[val] = true
        table.insert(chars, val)
      end
    end
  end

  return chars
end

--- Shows visual cues for each window.
--- @param targets table: Map of labels and their respective window objects.
--- @param opts table: Options for showing visual cues.
--- @return table: List of visual cues that were opened.
function M.show_cues(targets, opts)
  -- Reset view.
  local cues = {}
  for label, win in pairs(targets) do
    local bufnr = api.nvim_create_buf(false, true)

    if opts.format_label then
      label = opts.format_label(label, win.id, win.bufnr)
    end

    local padding = string.rep(" ", 4)
    local fill = string.rep(" ", label:len())

    local lines = {
      padding .. fill .. padding,
      padding .. label .. padding,
      padding .. fill .. padding,
    }

    api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)

    local width = label:len() + padding:len() * 2
    local height = 3

    local center_x = api.nvim_win_get_width(win.id) / 2
    local center_y = api.nvim_win_get_height(win.id) / 2

    local cue_winid = api.nvim_open_win(bufnr, false, {
      relative = "win",
      win = win.id,
      width = width,
      height = height,
      col = math.floor(center_x - width / 2),
      row = math.floor(center_y - height / 2),
      focusable = false,
      style = "minimal",
      border = opts.border,
    })

    pcall(api.nvim_buf_set_option, cue_winid, "buftype", "nofile")

    table.insert(cues, cue_winid)
  end

  return cues
end

--- Closes all windows for visual cues.
function M.hide_cues(cues)
  for _, win in pairs(cues) do
    -- We use pcall here because we dont' want to throw an error just
    -- because we couldn't close a window that was probably already closed!
    pcall(api.nvim_win_close, win, true)
  end
end

return M
