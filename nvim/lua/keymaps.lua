local keymap = vim.keymap.set
local utils = require("utils")

--------------------------------------------------------------------------------
-- Vim Motions
--------------------------------------------------------------------------------

-- 対応するカッコに移動
keymap("n", "M", "%", { noremap = true })
keymap("v", "M", "%", { noremap = true })

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
-- Editor Commands
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
-- Window Management (basic)
--------------------------------------------------------------------------------

-- Leader+数字 でエディタウィンドウ切り替え（1始まり、ファイラを除く）
for i = 1, 9 do
  keymap("n", "<leader>" .. i, function()
    local editor_wins = utils.get_editor_windows()
    if i <= #editor_wins then
      vim.api.nvim_set_current_win(editor_wins[i])
    end
  end, { noremap = true, silent = true, desc = "Go to editor window " .. i })
end

-- 新しいエディタウィンドウを右端に追加（均等幅に調整）
keymap("n", "<leader>\\", function()
  vim.cmd("botright vnew")
  vim.cmd("wincmd =")
end, { noremap = true, silent = true, desc = "Add new editor window" })

-- Neovim を終了
keymap("n", "<leader>Q", "<cmd>qa<CR>", { noremap = true, silent = true, desc = "Quit Neovim" })

--------------------------------------------------------------------------------
-- Window Resize
--------------------------------------------------------------------------------

keymap("n", "<C-S-Right>", "2<C-w>>",
  { noremap = true, silent = true, desc = "Expand window to right" })
keymap("n", "<C-S-Left>", "2<C-w><",
  { noremap = true, silent = true, desc = "Expand window to left" })

--------------------------------------------------------------------------------
-- Comment Toggle
--------------------------------------------------------------------------------

-- Normal mode: 現在行をコメントアウト/アンコメント
keymap("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle comment" })

-- Visual mode: 選択範囲をコメントアウト/アンコメント
keymap("v", "<leader>/", "gc", { remap = true, silent = true, desc = "Toggle comment" })
