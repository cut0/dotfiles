local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "folke/lazy.nvim", commit = "306a05526ada86a7b30af95c5cc81ffba93fef97" },
    { import = "plugins.colorscheme" },
    { import = "plugins.editor" },
    { import = "plugins.lsp" },
    { import = "plugins.completion" },
    { import = "plugins.format-lint" },
    { import = "plugins.telescope" },
    { import = "plugins.buffer" },
    { import = "plugins.statusline" },
    { import = "plugins.copilot" },
    { import = "plugins.git" },
    { import = "plugins.lang.rust" },
    { import = "plugins.lang.dart" },
    { import = "plugins.markdown" },
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
