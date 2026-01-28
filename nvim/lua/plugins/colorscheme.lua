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

        -- フォーカス/ハイライト系の統一色 (オレンジ #FC802D)
        local focus_bg = "#FC802D"
        local focus_fg = "#1d2021"

        -- LSP シンボルハイライト（カーソル下の同一シンボル）
        vim.api.nvim_set_hl(0, "LspReferenceText", { bg = focus_bg, fg = focus_fg, bold = true })
        vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = focus_bg, fg = focus_fg, bold = true })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = focus_bg, fg = focus_fg, bold = true, underline = true })

        -- 検索マッチハイライト
        vim.api.nvim_set_hl(0, "Search", { bg = focus_bg, fg = focus_fg, bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#fb4934", fg = focus_fg, bold = true })
        vim.api.nvim_set_hl(0, "CurSearch", { bg = "#fb4934", fg = focus_fg, bold = true })

        -- Telescope マッチハイライト
        vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = focus_bg, bold = true })
        vim.api.nvim_set_hl(0, "TelescopePreviewLine", { bg = focus_bg, fg = focus_fg, bold = true })

        -- Git サイン (左側の変更マーカー)
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#b8bb26" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = focus_bg })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#fb4934" })
        vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = focus_bg })
        vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#fb4934" })
        vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#b8bb26" })
      end

      set_custom_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_custom_highlights,
      })
    end,
  },
}
