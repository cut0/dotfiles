-- jj リポジトリかどうかを検出
local function is_jj_repo()
  return vim.fn.finddir(".jj", vim.fn.getcwd() .. ";") ~= ""
end

local is_jj = is_jj_repo()

return {
  -- インデント・チャンクハイライト
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          style = {
            { fg = "#806d9c" },
            { fg = "#c21f30" },
          },
          delay = 0,
        },
        indent = {
          enable = true,
          style = {
            { fg = "#665c54" },
          },
        },
        line_num = {
          enable = true,
          style = "#806d9c",
        },
        blank = {
          enable = false,
        },
      })
    end,
  },
  -- 検索結果ハイライト強化
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require("hlslens").setup({
        calm_down = true,
        nearest_only = true,
      })
      local kopts = { noremap = true, silent = true }
      vim.keymap.set(
        "n",
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.keymap.set(
        "n",
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },
  -- キーバインドヘルプ表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300,
      icons = {
        mappings = false,
      },
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>b", group = "buffer" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps",
      },
    },
  },
  {
    "rainbowhxch/accelerated-jk.nvim",
    event = "VeryLazy",
    config = function()
      require("accelerated-jk").setup()
    end,
    keys = {
      { "j", "<Plug>(accelerated_jk_gj)", mode = "n" },
      { "k", "<Plug>(accelerated_jk_gk)", mode = "n" },
    },
  },
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
    "Cretezy/neo-tree-jj.nvim",
    cond = is_jj,
    lazy = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = is_jj and {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "Cretezy/neo-tree-jj.nvim",
    } or {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()

      require("neo-tree").setup({
        sources = is_jj and {
          "filesystem",
          "buffers",
          "jj",
        } or {
          "filesystem",
          "buffers",
          "git_status",
        },
        source_selector = {
          winbar = true,
          sources = is_jj and {
            { source = "filesystem", display_name = " Files" },
            { source = "jj", display_name = "󰊢 JJ" },
            { source = "buffers", display_name = " Buffers" },
          } or {
            { source = "filesystem", display_name = " Files" },
            { source = "git_status", display_name = " Git" },
            { source = "buffers", display_name = " Buffers" },
          },
        },
        close_if_last_window = false,
        hide_root_node = true,
        enable_git_status = true,
        enable_diagnostics = false,
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              local state = require("neo-tree.sources.manager").get_state_for_window()
              if state and state.name then
                vim.g.neotree_last_source = state.name
              end
            end,
          },
        },
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        modified = {
          symbol = "●",
        },
        git_status = {
          symbols = {
            added = "A",
            modified = "M",
            deleted = "D",
            renamed = "R",
            untracked = "U",
            ignored = "◌",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = "none",
          ["o"] = "open",
          -- o* のデフォルトマッピングを無効化（o キーの遅延防止）
          -- oc: order_by_created (作成日時でソート)
          -- od: order_by_diagnostics (診断情報でソート)
          -- og: order_by_git_status (Git ステータスでソート)
          -- om: order_by_modified (修正日時でソート)
          -- on: order_by_name (ファイル名でソート)
          -- os: order_by_size (サイズでソート)
          -- ot: order_by_type (タイプでソート)
          ["oc"] = "none",
          ["od"] = "none",
          ["og"] = "none",
          ["om"] = "none",
          ["on"] = "none",
          ["os"] = "none",
          ["ot"] = "none",
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
          ["C"] = "close_node",
          ["a"] = { "add", config = { show_path = "relative" } },
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
          ["R"] = "refresh",
        },
      },
      filesystem = {
        bind_to_cwd = false,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { ".git", ".jj", "node_modules" },
        },
        follow_current_file = { enabled = true },
        group_empty_dirs = true,
      },
      jj = {
        window = {
          position = "left",
          mappings = {
            ["o"] = "open",
            ["oc"] = "none",
            ["od"] = "none",
            ["og"] = "none",
            ["om"] = "none",
            ["on"] = "none",
            ["os"] = "none",
            ["ot"] = "none",
          },
        },
      },
      })
    end,
  },
}
