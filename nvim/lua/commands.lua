local function copy_relative_path()
  local path = vim.fn.expand("%")
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

local function get_github_url()
  local file = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local remote = vim.fn.system("git remote get-url origin"):gsub("\n", "")

  remote = remote:gsub("git@github.com:", "https://github.com/")
  remote = remote:gsub("%.git$", "")

  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local rel_path = file:gsub("^" .. vim.fn.escape(git_root, "%-%.") .. "/", "")

  return remote .. "/blob/" .. branch .. "/" .. rel_path .. "#L" .. line
end

local function open_in_github()
  local url = get_github_url()
  vim.fn.system("open " .. url)
  vim.notify("Opened in GitHub", vim.log.levels.INFO)
end

local function copy_github_url()
  local url = get_github_url()
  vim.fn.setreg("+", url)
  vim.notify("Copied GitHub URL", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Cut0CopyRelativePath", copy_relative_path, { desc = "Copy relative file path" })
vim.api.nvim_create_user_command("Cut0CopyAbsolutePath", copy_absolute_path, { desc = "Copy absolute file path" })
vim.api.nvim_create_user_command("Cut0CopyFilename", copy_filename, { desc = "Copy filename" })
vim.api.nvim_create_user_command("Cut0OpenInGitHub", open_in_github, { desc = "Open current file in GitHub" })
vim.api.nvim_create_user_command("Cut0CopyGitHubURL", copy_github_url, { desc = "Copy GitHub URL of current file" })
