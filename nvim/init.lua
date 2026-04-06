vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard:append("unnamedplus")

if not vim.g.vscode then
  require("plugins")
  require("options")
  require("keymaps")
  require("autocmds")
  require("commands")
  require("lsp_setup").setup()

  vim.lsp.enable({
    "ts_ls",
    "denols",
    "biome",
    "gopls",
    "lua_ls",
    "eslint",
    "oxlint",
  })
end
