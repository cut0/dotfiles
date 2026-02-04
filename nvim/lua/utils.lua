local M = {}

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

M.filer_filetypes = { "neo-tree", "NvimTree", "nvim-tree" }

--------------------------------------------------------------------------------
-- Window Utilities
--------------------------------------------------------------------------------

-- ファイラ以外のエディタウィンドウを取得
function M.get_editor_windows()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local editor_wins = {}

  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if not vim.tbl_contains(M.filer_filetypes, ft) then
      table.insert(editor_wins, win)
    end
  end

  return editor_wins
end

-- ターゲットウィンドウを取得（偶数→n+1、奇数→n-1、n=1→n+1）
-- ファイラを除いたエディタウィンドウのみを対象
function M.get_target_window()
  local current_win = vim.api.nvim_get_current_win()
  local wins = M.get_editor_windows()

  -- 現在のウィンドウの位置（1-indexed）
  local n = 0
  for i, win in ipairs(wins) do
    if win == current_win then
      n = i
      break
    end
  end

  local target_n
  if n == 1 or n % 2 == 0 then
    target_n = n + 1
  else
    target_n = n - 1
  end

  if target_n <= #wins then
    return wins[target_n]
  else
    vim.cmd("botright vsplit")
    vim.cmd("wincmd =")
    return vim.api.nvim_get_current_win()
  end
end

-- ターゲットウィンドウにファイルを開く
function M.open_in_target_window(filename, lnum, col)
  local target_win = M.get_target_window()
  vim.api.nvim_set_current_win(target_win)
  vim.cmd("edit " .. vim.fn.fnameescape(filename))
  if lnum then
    vim.api.nvim_win_set_cursor(target_win, { lnum, (col or 1) - 1 })
  end
end

return M
