return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_transparent_background = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

      vim.cmd.colorscheme("gruvbox-material")

      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "NONE", fg = "#3c3836" })
    end,
  },
}
