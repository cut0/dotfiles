return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      -- パーサーのインストール設定
      require("nvim-treesitter").setup({
        ensure_installed = {
          "markdown",
          "markdown_inline",
          "lua",
          "vim",
          "vimdoc",
          "typescript",
          "tsx",
          "javascript",
          "go",
          "rust",
          "python",
          "json",
          "yaml",
          "toml",
          "html",
          "css",
        },
      })
    end,
  },
}
