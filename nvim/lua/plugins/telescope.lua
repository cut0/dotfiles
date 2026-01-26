return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      --------------------------------------------------------------------------
      -- Search Patterns Configuration (VSCode-like)
      --------------------------------------------------------------------------

      -- 検索から除外するパターン (glob pattern)
      local exclude_patterns = {
        -- Dependencies
        "node_modules",
        "vendor",
        ".venv",
        "__pycache__",

        -- Version Control
        ".git/",

        -- Build outputs
        "dist",
        "build",
        "out",
        "target",

        -- Lock files
        "%.lock",
        "package%-lock%.json",

        -- Cache & temp
        ".cache",
        ".next",
        ".nuxt",
        "%.tmp",

        -- Binary & media (by extension)
        "%.png",
        "%.jpg",
        "%.jpeg",
        "%.gif",
        "%.ico",
        "%.pdf",
        "%.woff",
        "%.woff2",
        "%.ttf",
      }

      -- 検索に含めるパターン (live_grep 用, glob pattern)
      -- 空の場合は全ファイルが対象
      local include_patterns = {
        -- "*.lua",
        -- "*.ts",
        -- "*.tsx",
        -- "*.js",
        -- "*.jsx",
        -- "*.go",
        -- "*.rs",
        -- "*.py",
        -- "*.md",
      }

      --------------------------------------------------------------------------
      -- Telescope Setup
      --------------------------------------------------------------------------

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
            },
          },
          path_display = { "truncate" },
          color_devicons = true,
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
          file_ignore_patterns = exclude_patterns,
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              local args = { "--hidden" }
              -- include_patterns が設定されている場合は glob を追加
              for _, pattern in ipairs(include_patterns) do
                table.insert(args, "--glob")
                table.insert(args, pattern)
              end
              return args
            end,
          },
          lsp_references = { show_line = false },
          lsp_definitions = { show_line = false },
          lsp_type_definitions = { show_line = false },
          lsp_implementations = { show_line = false },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
