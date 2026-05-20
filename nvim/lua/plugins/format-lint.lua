return {
  {
    "stevearc/conform.nvim",
    commit = "086a40dc7ed8242c03be9f47fbcee68699cc2395",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>=",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "oxformat", "biome", "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "oxformat", "biome", "prettierd", "prettier", stop_after_first = true },
        typescript = { "oxformat", "biome", "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "oxformat", "biome", "prettierd", "prettier", stop_after_first = true },
        json = { "biome", "prettierd", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },

        go = { "gofmt", "goimports" },
        lua = { "stylua" },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      formatters = {
        biome = {
          require_cwd = true,
        },
        oxformat = {
          command = "oxformat",
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
          require_cwd = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    commit = "4b03656c09c1561f89b6aa0665c15d292ba9499d",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        go = { "golangcilint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
