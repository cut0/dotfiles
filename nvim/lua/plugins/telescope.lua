return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
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
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    keys = {
      {
        "<leader>tg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            default_text = '"" --glob ""',
          })
        end,
        desc = "Live grep with args",
      },
      {
        "<leader>tr",
        function()
          local search = vim.fn.getreg("/")
          local cmd = ":noautocmd cfdo %s/" .. search .. "//g | update"
          local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
          vim.api.nvim_feedkeys(cmd .. string.rep(left, 12), "n", false)
        end,
        desc = "Replace in quickfix (fast)",
      },
      {
        "<leader>tp",
        function() require("telescope.builtin").find_files() end,
        desc = "Find files",
      },
      {
        "<leader>tc",
        function() require("telescope.builtin").commands() end,
        desc = "Commands",
      },
      {
        "<leader>tf",
        function() require("telescope.builtin").live_grep() end,
        desc = "Live grep",
      },
      {
        "<leader>tb",
        function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local buffers = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
              local name = vim.api.nvim_buf_get_name(buf)
              if name ~= "" then
                local order = _G.buffer_open_order[buf] or 0
                local time = _G.buffer_open_times[buf] or "??:??:??"
                table.insert(buffers, {
                  bufnr = buf,
                  name = name,
                  order = order,
                  time = time,
                })
              end
            end
          end

          table.sort(buffers, function(a, b)
            return a.order > b.order
          end)

          pickers.new({}, {
            prompt_title = "Buffers",
            finder = finders.new_table({
              results = buffers,
              entry_maker = function(entry)
                local filename = vim.fn.fnamemodify(entry.name, ":t")
                local dir = vim.fn.fnamemodify(entry.name, ":h:t")
                return {
                  value = entry,
                  display = entry.time .. "  " .. filename .. "  (" .. dir .. ")",
                  ordinal = filename,
                  bufnr = entry.bufnr,
                  filename = entry.name,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                  vim.api.nvim_set_current_buf(selection.bufnr)
                end
              end)
              return true
            end,
          }):find()
        end,
        desc = "Buffers (by open time)",
      },
    },
    lazy = false,
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
          cache_picker = {
            num_pickers = 10,
            limit_entries = 1000,
          },
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
      pcall(telescope.load_extension, "live_grep_args")
    end,
  },
}
