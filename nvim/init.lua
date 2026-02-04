-- Neovim 0.11 compatibility shim (must be before any plugin loads)
---@diagnostic disable-next-line: undefined-field
if not vim.treesitter.language.ft_to_lang then
  ---@diagnostic disable-next-line: inject-field
  vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard:append("unnamedplus")

if not vim.g.vscode then
  require("plugins")
  require("options")
  require("keymaps")
  require("autocmds")
  require("commands")
end
