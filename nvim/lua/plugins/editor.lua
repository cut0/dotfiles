return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = {
      override_by_extension = {
        ["ts"] = {
          icon = "󰛦",
          color = "#3178c6",
          name = "TypeScript",
        },
        ["tsx"] = {
          icon = "⚛",
          color = "#61dafb",
          name = "TypeScriptReact",
        },
        ["js"] = {
          icon = "󰌞",
          color = "#f7df1e",
          name = "JavaScript",
        },
        ["jsx"] = {
          icon = "⚛",
          color = "#61dafb",
          name = "JavaScriptReact",
        },
        ["json"] = {
          icon = "",
          color = "#cbcb41",
          name = "Json",
        },
        ["md"] = {
          icon = "",
          color = "#519aba",
          name = "Markdown",
        },
        ["lua"] = {
          icon = "",
          color = "#51a0cf",
          name = "Lua",
        },
        ["go"] = {
          icon = "",
          color = "#00add8",
          name = "Go",
        },
        ["rs"] = {
          icon = "",
          color = "#dea584",
          name = "Rust",
        },
        ["py"] = {
          icon = "",
          color = "#ffbc03",
          name = "Python",
        },
        ["dart"] = {
          icon = "",
          color = "#03589C",
          name = "Dart",
        },
        ["yaml"] = {
          icon = "",
          color = "#6d8086",
          name = "Yaml",
        },
        ["yml"] = {
          icon = "",
          color = "#6d8086",
          name = "Yaml",
        },
        ["toml"] = {
          icon = "",
          color = "#6d8086",
          name = "Toml",
        },
        ["lock"] = {
          icon = "",
          color = "#6d8086",
          name = "Lock",
        },
        ["env"] = {
          icon = "",
          color = "#faf743",
          name = "Env",
        },
      },
      default = true,
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
          signcolumn = "yes",
        },
        renderer = {
          root_folder_label = false,
          group_empty = true,
          highlight_git = "none",
          highlight_opened_files = "name",
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              bookmark = "󰆤",
              modified = "●",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "M",
                staged = "A",
                unmerged = "",
                renamed = "R",
                untracked = "U",
                deleted = "D",
                ignored = "◌",
              },
            },
          },
        },
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        diagnostics = {
          enable = false,
        },
        filters = {
          dotfiles = false,
          custom = { "^.git$", "node_modules", ".cache" },
        },
        git = {
          enable = true,
          ignore = false,
          show_on_dirs = false,
          show_on_open_dirs = false,
        },
        modified = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
      })
    end,
  },
}
