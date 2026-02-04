local function copy_relative_path()
  local absolute_path = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  local path = vim.fn.fnamemodify(absolute_path, ":." )
  -- fnamemodify が相対パスに変換できなかった場合のフォールバック
  if path:sub(1, 1) == "/" then
    -- cwd からの相対パスを手動で計算
    if absolute_path:sub(1, #cwd) == cwd then
      path = absolute_path:sub(#cwd + 2) -- +2 for trailing slash
    end
  end
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end

local function copy_absolute_path()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end

local function copy_filename()
  local filename = vim.fn.expand("%:t")
  vim.fn.setreg("+", filename)
  vim.notify("Copied: " .. filename, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Cut0CopyRelativePath", copy_relative_path, { desc = "Copy relative file path" })
vim.api.nvim_create_user_command("Cut0CopyAbsolutePath", copy_absolute_path, { desc = "Copy absolute file path" })
vim.api.nvim_create_user_command("Cut0CopyFilename", copy_filename, { desc = "Copy filename" })
