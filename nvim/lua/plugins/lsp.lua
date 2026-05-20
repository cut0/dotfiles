return {
  {
    "williamboman/mason.nvim",
    version = "v2.2.1",
    lazy = false,
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
}
