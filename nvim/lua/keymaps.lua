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
keymap("n", "<leader>w", "<cmd>w<CR>", { noremap = true, silent = true, desc = "Save file" })


-- 全選択
keymap("n", "<leader>a", "ggVG", { noremap = true, silent = true, desc = "Select all" })

-- 折り返し表示の切り替え
keymap("n", "<leader>z", function()
  vim.wo.wrap = not vim.wo.wrap
end, { noremap = true, silent = true, desc = "Toggle word wrap" })

--------------------------------------------------------------------------------
-- File Tree
--------------------------------------------------------------------------------

-- 最後に開いた neo-tree ソースを記憶
vim.g.neotree_last_source = "filesystem"

keymap("n", "<leader>b", function()
  local source = vim.g.neotree_last_source or "filesystem"
  vim.cmd("Neotree toggle source=" .. source)
end, { noremap = true, silent = true, desc = "Toggle file tree" })
keymap("n", "<leader>e", function()
  local source = vim.g.neotree_last_source or "filesystem"
  vim.cmd("Neotree focus source=" .. source)
end, { noremap = true, silent = true, desc = "Focus file tree" })

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

keymap("n", "<leader>p", function()
  require("telescope.builtin").find_files()
end, { noremap = true, silent = true, desc = "Find files" })

keymap("n", "<leader>P", function()
  require("telescope.builtin").commands()
end, { noremap = true, silent = true, desc = "Command palette" })

-- leader+f: live_grep
keymap("n", "<leader>f", function()
  require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "Live grep" })

keymap("n", "<leader>g", live_grep_with_filters, { noremap = true, silent = true, desc = "Search with filters" })

-- keymap("n", "<leader>ff", function() require("telescope.builtin").find_files() end,
--   { noremap = true, silent = true, desc = "Find files" })
-- keymap("n", "<leader>fg", function() require("telescope.builtin").live_grep() end,
--   { noremap = true, silent = true, desc = "Live grep" })
-- keymap("n", "<leader>fG", live_grep_with_filters,
--   { noremap = true, silent = true, desc = "Live grep (with filters)" })
-- keymap("n", "<leader>fb", function() require("telescope.builtin").buffers() end,
--   { noremap = true, silent = true, desc = "Find buffers" })
-- keymap("n", "<leader>fh", function() require("telescope.builtin").help_tags() end,
--   { noremap = true, silent = true, desc = "Help tags" })
-- keymap("n", "<leader>fc", function() require("telescope.builtin").commands() end,
--   { noremap = true, silent = true, desc = "Commands" })
-- keymap("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end,
--   { noremap = true, silent = true, desc = "Recent files" })
-- keymap("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end,
--   { noremap = true, silent = true, desc = "Document symbols" })
-- keymap("n", "<leader>fS", function() require("telescope.builtin").lsp_workspace_symbols() end,
--   { noremap = true, silent = true, desc = "Workspace symbols" })

--------------------------------------------------------------------------------
-- Window Management
--------------------------------------------------------------------------------

-- neo-tree を除いたエディタウィンドウ一覧を取得
local function get_editor_windows()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft ~= "neo-tree" then
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

-- Leader+数字 でウィンドウ切り替え
for i = 1, 9 do
  keymap("n", "<leader>" .. i, function() goto_editor_window(i) end,
    { noremap = true, silent = true, desc = "Go to editor window " .. i })
end

-- 新しいエディタウィンドウを右端に追加（均等幅に調整）
keymap("n", "<leader>\\", function()
  vim.cmd("botright vnew")
  vim.cmd("wincmd =")
end, { noremap = true, silent = true, desc = "Add new editor window" })

-- バッファ/ウィンドウを閉じる
keymap("n", "<leader>x", function()
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

-- Neovim を終了
keymap("n", "<leader>Q", "<cmd>qa<CR>", { noremap = true, silent = true, desc = "Quit Neovim" })

-- 全ウィンドウを閉じる
keymap("n", "<leader>X", function()
  vim.cmd("only")
  vim.cmd("enew")
end, { noremap = true, silent = true, desc = "Close all windows" })

--------------------------------------------------------------------------------
-- Window Buffer Stack Management
--------------------------------------------------------------------------------

-- ウィンドウごとのバッファスタックを管理
local window_buffer_stacks = {}

-- ウィンドウのバッファスタックを取得
local function get_window_stack(win)
  if not window_buffer_stacks[win] then
    window_buffer_stacks[win] = {}
  end
  return window_buffer_stacks[win]
end

-- スタックにバッファを追加（重複は削除して先頭に）
local function push_buffer_to_stack(win, buf)
  -- ファイラーのバッファは追加しない
  local ft = vim.bo[buf].filetype
  if ft == "neo-tree" or ft == "oil" or ft == "" then
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then return end
  end

  local stack = get_window_stack(win)

  -- 既に存在する場合は削除
  for i, b in ipairs(stack) do
    if b == buf then
      table.remove(stack, i)
      break
    end
  end

  -- 先頭に追加
  table.insert(stack, 1, buf)
end

-- スタックからバッファを削除
local function remove_buffer_from_stack(win, buf)
  local stack = get_window_stack(win)
  for i, b in ipairs(stack) do
    if b == buf then
      table.remove(stack, i)
      break
    end
  end
end

-- スタックの次のバッファを取得（有効なバッファのみ）
local function get_next_buffer_from_stack(win, exclude_buf)
  local stack = get_window_stack(win)
  for _, buf in ipairs(stack) do
    if buf ~= exclude_buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      return buf
    end
  end
  return nil
end

-- BufEnter でスタックを更新
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    push_buffer_to_stack(win, buf)
  end,
})

-- ウィンドウが閉じられたらスタックを削除
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(args)
    local win = tonumber(args.match)
    if win then
      window_buffer_stacks[win] = nil
    end
  end,
})

-- バッファを隣のウィンドウに移動する
local function move_buffer_to_adjacent_window(direction)
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)

  -- 現在のウィンドウがエディタウィンドウか確認
  local ft = vim.bo[current_buf].filetype
  if ft == "neo-tree" or ft == "oil" then
    return
  end

  -- エディタウィンドウ一覧を取得
  local editor_wins = get_editor_windows()
  if #editor_wins < 2 then
    return
  end

  -- 現在のウィンドウの位置を取得
  local current_pos = vim.api.nvim_win_get_position(current_win)
  local current_row, current_col = current_pos[1], current_pos[2]

  -- 隣接するウィンドウを探す
  local target_win = nil
  local best_distance = math.huge

  for _, win in ipairs(editor_wins) do
    if win ~= current_win then
      local pos = vim.api.nvim_win_get_position(win)
      local row, col = pos[1], pos[2]

      local is_valid = false
      local distance = 0

      if direction == "left" and col < current_col then
        is_valid = true
        distance = current_col - col
      elseif direction == "right" and col > current_col then
        is_valid = true
        distance = col - current_col
      elseif direction == "up" and row < current_row then
        is_valid = true
        distance = current_row - row
      elseif direction == "down" and row > current_row then
        is_valid = true
        distance = row - current_row
      end

      if is_valid and distance < best_distance then
        best_distance = distance
        target_win = win
      end
    end
  end

  if not target_win then
    return
  end

  -- 現在のウィンドウのスタックからバッファを削除
  remove_buffer_from_stack(current_win, current_buf)

  -- ターゲットウィンドウのスタックにバッファを追加
  push_buffer_to_stack(target_win, current_buf)

  -- ターゲットウィンドウにバッファを開く
  vim.api.nvim_win_set_buf(target_win, current_buf)

  -- 現在のウィンドウで次のバッファを表示（スタックから取得）
  local next_buf = get_next_buffer_from_stack(current_win, current_buf)

  if next_buf then
    vim.api.nvim_win_set_buf(current_win, next_buf)
  else
    -- スタックにバッファがない場合は新しい空バッファを作成
    local new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_win_set_buf(current_win, new_buf)
  end

  -- ターゲットウィンドウにフォーカスを移す
  vim.api.nvim_set_current_win(target_win)
end

keymap("n", "<leader><S-Left>", function() move_buffer_to_adjacent_window("left") end,
  { noremap = true, silent = true, desc = "Move buffer to left window" })
keymap("n", "<leader><S-Right>", function() move_buffer_to_adjacent_window("right") end,
  { noremap = true, silent = true, desc = "Move buffer to right window" })
keymap("n", "<leader><S-Up>", function() move_buffer_to_adjacent_window("up") end,
  { noremap = true, silent = true, desc = "Move buffer to upper window" })
keymap("n", "<leader><S-Down>", function() move_buffer_to_adjacent_window("down") end,
  { noremap = true, silent = true, desc = "Move buffer to lower window" })

--------------------------------------------------------------------------------
-- Comment Toggle
--------------------------------------------------------------------------------

-- Normal mode: 現在行をコメントアウト/アンコメント
keymap("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle comment" })

-- Visual mode: 選択範囲をコメントアウト/アンコメント
keymap("v", "<leader>/", "gc", { remap = true, silent = true, desc = "Toggle comment" })

--------------------------------------------------------------------------------
-- Window Resize
--------------------------------------------------------------------------------

keymap("n", "<C-S-Right>", "2<C-w>>",
  { noremap = true, silent = true, desc = "Expand window to right" })
keymap("n", "<C-S-Left>", "2<C-w><",
  { noremap = true, silent = true, desc = "Expand window to left" })
