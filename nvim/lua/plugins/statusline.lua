-- jj リポジトリかどうかを検出
local function is_jj_repo()
  return vim.fn.finddir(".jj", vim.fn.getcwd() .. ";") ~= ""
end

local is_jj = is_jj_repo()

-- jj 用カスタムコンポーネント: change_id + bookmark
local function jj_status()
  local summary = vim.b.jjtrack_summary
  if not summary then
    return ""
  end

  local parts = {}

  -- ブックマーク名（あれば）
  if summary.bookmarks and #summary.bookmarks > 0 then
    table.insert(parts, summary.bookmarks[1])
  end

  -- change_id (短縮形)
  if summary.change_id_prefix then
    table.insert(parts, summary.change_id_prefix)
  end

  return table.concat(parts, " ")
end

return {
  -- jj 用: jjtrack
  {
    "lucasadelino/jjtrack",
    cond = is_jj,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("jjtrack").setup()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "gruvbox-material",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "neo-tree" },
        },
      },
      sections = {
        lualine_a = {
          { "mode", fmt = function(str) return str:sub(1, 1) end },
        },
        lualine_b = is_jj and {
          { jj_status, icon = "󰊢" },
        } or {
          { "branch", icon = "" },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_y = {
          { "encoding", show_bomb = true },
          { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
        },
        lualine_z = {
          { "location" },
          { "progress" },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
