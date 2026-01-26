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

      local function set_custom_highlights()
        vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE", fg = "NONE" })
        vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "NONE", fg = "#3c3836" })

        -- LSP シンボルハイライト（カーソル下の同一シンボル）
        vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#45403d", bold = true })
        vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#45403d", bold = true })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#5a524c", bold = true, underline = true })

        -- 検索マッチハイライト
        vim.api.nvim_set_hl(0, "Search", { bg = "#fabd2f", fg = "#1d2021", bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#fb4934", fg = "#1d2021", bold = true })
        vim.api.nvim_set_hl(0, "CurSearch", { bg = "#fb4934", fg = "#1d2021", bold = true })

        -- Telescope マッチハイライト
        vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#fabd2f", bold = true })
      end

      set_custom_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_custom_highlights,
      })
    end,
  },
}
