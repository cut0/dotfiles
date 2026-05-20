return {
  -- インデント・チャンクハイライト
  {
    "shellRaining/hlchunk.nvim",
    commit = "3bc2bd7aef28fbed6643534a0fdd0f19966544bc",
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
    commit = "be2d7b2be01860b5445a007ff2bc72b29896db6b",
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
    commit = "3aab2147e74890957785941f0c1ad87d0a44c15a",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300,
      icons = {
        mappings = false,
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
    commit = "8fb5dad4ccc1811766cebf16b544038aeeb7806f",
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
    commit = "40e9d5a6cc3db11b309e39593fc7ac03bb844e38",
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
    "nvim-neo-tree/neo-tree.nvim",
    version = "3.41.0",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim", commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509" },
      "nvim-tree/nvim-web-devicons",
      { "MunifTanjim/nui.nvim", commit = "de740991c12411b663994b2860f1a4fd0937c130" },
    },
    keys = {
      {
        "<leader>b",
        function() vim.cmd("Neotree toggle source=filesystem") end,
        desc = "Toggle file tree",
      },
      {
        "<leader>e",
        function() vim.cmd("Neotree focus source=filesystem") end,
        desc = "Focus file tree",
      },
    },
    config = function()
      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
        },
        source_selector = {
          winbar = true,
          sources = {
            { source = "filesystem", display_name = " Files" },
          },
        },
        close_if_last_window = false,
        hide_root_node = true,
        enable_git_status = true,
        enable_diagnostics = false,
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
        file_size = {
          enabled = true,
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
        width = 50,
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
          ["E"] = "expand_all_nodes",
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
        renderers = {
          file = {
            { "indent" },
            { "icon" },
            { "name", use_git_status_colors = true },
            { "modified", zindex = 20, align = "right" },
            { "git_status", zindex = 20, align = "right" },
            { "file_size", zindex = 10, align = "right" },
          },
        },
      },
      })
    end,
  },
  -- 対応するカッコ・タグへのジャンプ拡張
  {
    "andymass/vim-matchup",
    commit = "0fb1e6b7cea34e931a2af50b8ad565c5c4fd8f4d",
    event = "VeryLazy",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -- マルチカーソル
  {
    "mg979/vim-visual-multi",
    commit = "a6975e7c1ee157615bbc80fc25e4392f71c344d4",
    event = "VeryLazy",
    init = function()
      vim.g.VM_default_mappings = 1
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Add Cursor Down"] = "<C-Down>",
        ["Add Cursor Up"] = "<C-Up>",
        ["Select All"] = "<C-S-n>",
        ["Skip Region"] = "<C-x>",
        ["Remove Region"] = "<C-p>",
      }
      vim.g.VM_theme = "iceblue"
    end,
  },
}
