local keymap = vim.keymap.set

--------------------------------------------------------------------------------
-- Vim Motions
--------------------------------------------------------------------------------

-- 対応するカッコに移動
keymap("n", "M", "%", { noremap = true })
keymap("v", "M", "%", { noremap = true })

-- 表示行単位での移動
keymap("n", "j", "gj", { noremap = true })
keymap("v", "j", "gj", { noremap = true })
keymap("n", "k", "gk", { noremap = true })
keymap("v", "k", "gk", { noremap = true })

-- 行頭・行末への移動
keymap("n", "H", "g0", { noremap = true })
keymap("v", "H", "g0", { noremap = true })
keymap("n", "L", "g$", { noremap = true })
keymap("v", "L", "g$", { noremap = true })

-- 削除系はレジスタに入れない
keymap("n", "d", '"_d', { noremap = true })
keymap("v", "d", '"_d', { noremap = true })
keymap("n", "D", '"_D', { noremap = true })
keymap("v", "D", '"_D', { noremap = true })
keymap("n", "dd", '"_dd', { noremap = true })
keymap("n", "c", '"_c', { noremap = true })
keymap("v", "c", '"_c', { noremap = true })

-- ビジュアルモードでのコピー時に位置を保持
keymap("x", "y", "mzy`z", { noremap = true })

-- Redo を U に割り当て
keymap("n", "U", "<C-r>", { noremap = true })

-- Insert mode: jj で Normal mode へ
keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

--------------------------------------------------------------------------------
-- Editor Commands (via WezTerm Cmd key)
--------------------------------------------------------------------------------

-- 保存
keymap("n", "<M-s>", "<cmd>w<CR>", { noremap = true, silent = true, desc = "Save file" })
keymap("i", "<M-s>", "<cmd>w<CR>", { noremap = true, silent = true, desc = "Save file" })

-- Undo / Redo (Cmd+Z / Cmd+Shift+Z)
keymap("n", "<M-C-z>", "u", { noremap = true, silent = true, desc = "Undo" })
keymap("i", "<M-C-z>", "<C-o>u", { noremap = true, silent = true, desc = "Undo" })
keymap("n", "<M-C-S-z>", "<C-r>", { noremap = true, silent = true, desc = "Redo" })
keymap("i", "<M-C-S-z>", "<C-o><C-r>", { noremap = true, silent = true, desc = "Redo" })

-- 全選択
keymap("n", "<M-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })
keymap("i", "<M-a>", "<Esc>ggVG", { noremap = true, silent = true, desc = "Select all" })

-- 折り返し表示の切り替え (Option+Z)
keymap("n", "<M-z>", function()
  vim.wo.wrap = not vim.wo.wrap
end, { noremap = true, silent = true, desc = "Toggle word wrap" })

--------------------------------------------------------------------------------
-- File Tree
--------------------------------------------------------------------------------

keymap("n", "<M-b>", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle file tree" })
keymap("n", "<M-e>", "<cmd>NvimTreeFocus<CR>", { noremap = true, silent = true, desc = "Focus file tree" })

--------------------------------------------------------------------------------
-- Search (Telescope)
--------------------------------------------------------------------------------

-- 検索フィルタの状態を保存するファイル
local filter_cache_file = vim.fn.stdpath("data") .. "/search_filters.json"

-- フィルタ状態を読み込み
local function load_filters()
  local file = io.open(filter_cache_file, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok and data then
      return data
    end
  end
  return { include = "", exclude = "" }
end

-- フィルタ状態を保存
local function save_filters(filters)
  local file = io.open(filter_cache_file, "w")
  if file then
    file:write(vim.json.encode(filters))
    file:close()
  end
end

-- 詳細検索: Cmd+Shift+G
local function live_grep_with_filters()
  local filters = load_filters()

  vim.ui.input({
    prompt = "Include (glob): ",
    default = filters.include,
  }, function(include)
    if include == nil then return end

    vim.ui.input({
      prompt = "Exclude (glob): ",
      default = filters.exclude,
    }, function(exclude)
      if exclude == nil then return end

      -- フィルタを保存
      save_filters({ include = include, exclude = exclude })

      local args = { "--hidden" }

      -- include パターンを追加
      if include ~= "" then
        for pattern in include:gmatch("[^,]+") do
          pattern = vim.trim(pattern)
          if pattern ~= "" then
            table.insert(args, "--glob")
            table.insert(args, pattern)
          end
        end
      end

      -- exclude パターンを追加
      if exclude ~= "" then
        for pattern in exclude:gmatch("[^,]+") do
          pattern = vim.trim(pattern)
          if pattern ~= "" then
            table.insert(args, "--glob")
            table.insert(args, "!" .. pattern)
          end
        end
      end

      require("telescope.builtin").live_grep({
        prompt_title = "Search in Files",
        additional_args = function() return args end,
      })
    end)
  end)
end

keymap("n", "<M-f>", function()
  require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "Search in project" })

keymap("n", "<M-G>", live_grep_with_filters, { noremap = true, silent = true, desc = "Search with filters" })

keymap("n", "<M-p>", function()
  require("telescope.builtin").find_files()
end, { noremap = true, silent = true, desc = "Find files" })

keymap("n", "<M-P>", function()
  require("telescope.builtin").commands()
end, { noremap = true, silent = true, desc = "Command palette" })

keymap("n", "<leader>ff", function() require("telescope.builtin").find_files() end,
  { noremap = true, silent = true, desc = "Find files" })
keymap("n", "<leader>fg", function() require("telescope.builtin").live_grep() end,
  { noremap = true, silent = true, desc = "Live grep" })
keymap("n", "<leader>fG", live_grep_with_filters,
  { noremap = true, silent = true, desc = "Live grep (with filters)" })
keymap("n", "<leader>fb", function() require("telescope.builtin").buffers() end,
  { noremap = true, silent = true, desc = "Find buffers" })
keymap("n", "<leader>fh", function() require("telescope.builtin").help_tags() end,
  { noremap = true, silent = true, desc = "Help tags" })
keymap("n", "<leader>fc", function() require("telescope.builtin").commands() end,
  { noremap = true, silent = true, desc = "Commands" })
keymap("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end,
  { noremap = true, silent = true, desc = "Recent files" })
keymap("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end,
  { noremap = true, silent = true, desc = "Document symbols" })
keymap("n", "<leader>fS", function() require("telescope.builtin").lsp_workspace_symbols() end,
  { noremap = true, silent = true, desc = "Workspace symbols" })

--------------------------------------------------------------------------------
-- Window Management
--------------------------------------------------------------------------------

-- NvimTree を除いたエディタウィンドウ一覧を取得
local function get_editor_windows()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft ~= "NvimTree" then
      table.insert(wins, win)
    end
  end
  return wins
end

-- n 番目のエディタウィンドウへ移動
local function goto_editor_window(n)
  local wins = get_editor_windows()
  if n <= #wins then
    vim.api.nvim_set_current_win(wins[n])
  end
end

-- Cmd+数字 でウィンドウ切り替え
for i = 1, 9 do
  keymap("n", "<M-" .. i .. ">", function() goto_editor_window(i) end,
    { noremap = true, silent = true, desc = "Go to editor window " .. i })
end

-- 新しいエディタウィンドウを追加 (Cmd+\)
keymap("n", "<M-\\>", function()
  vim.cmd("vsplit")
  vim.cmd("enew")
end, { noremap = true, silent = true, desc = "Add new editor window" })

-- バッファ/ウィンドウを閉じる (Cmd+W)
keymap("n", "<M-w>", function()
  local win_count = #vim.api.nvim_list_wins()
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(current_buf)
  local buf_modified = vim.bo[current_buf].modified
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })

  local is_empty = buf_name == "" and not buf_modified

  if (is_empty or #bufs <= 1) and win_count > 1 then
    vim.cmd("close")
  else
    require("mini.bufremove").delete(0, false)
  end
end, { noremap = true, silent = true, desc = "Close current buffer" })

-- Neovim を終了 (Cmd+Q)
keymap("n", "<M-q>", "<cmd>qa<CR>", { noremap = true, silent = true, desc = "Quit Neovim" })

-- 全ウィンドウを閉じる (Cmd+Shift+W)
keymap("n", "<M-S-w>", function()
  vim.cmd("only")
  vim.cmd("enew")
end, { noremap = true, silent = true, desc = "Close all windows" })

-- ウィンドウリサイズ (Ctrl+Shift+Arrow)
keymap("n", "<C-S-Right>", "<cmd>vertical resize +5<CR>",
  { noremap = true, silent = true, desc = "Increase window width" })
keymap("n", "<C-S-Left>", "<cmd>vertical resize -5<CR>",
  { noremap = true, silent = true, desc = "Decrease window width" })

--------------------------------------------------------------------------------
-- Terminal
--------------------------------------------------------------------------------

keymap("n", "<M-m>", function()
  _G.toggle_fullscreen_terminal()
end, { noremap = true, silent = true, desc = "Toggle fullscreen terminal" })

keymap("t", "<M-m>", function()
  _G.toggle_fullscreen_terminal()
end, { noremap = true, silent = true, desc = "Toggle fullscreen terminal" })
