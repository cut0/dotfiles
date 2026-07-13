-- grep 系の結果を「ファイル名:行数」のみで表示する entry maker
-- 同一ファイルが連続する場合、2 件目以降はファイル名を省略する
local function grep_entry_maker()
  local base = require("telescope.make_entry").gen_from_vimgrep({})
  local last_filename
  return function(line)
    local entry = base(line)
    if entry then
      local abbrev = entry.filename == last_filename
      last_filename = entry.filename
      entry.display = function(e)
        if abbrev then
          return " └ :" .. e.lnum
        end
        return vim.fn.fnamemodify(e.filename, ":~:.") .. ":" .. e.lnum
      end
    end
    return entry
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    commit = "cfb85dcf7f822b79224e9e6aef9e8c794211b20b",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        commit = "6fea601bd2b694c6f2ae08a6c6fab14930c60e2c",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-live-grep-args.nvim", commit = "b80ec2c70ec4f32571478b501218c8979fab5201" },
    },
    keys = {
      {
        "<leader>tg",
        function()
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local save_input = function(prompt_bufnr)
            local picker = action_state.get_current_picker(prompt_bufnr)
            vim.g.last_grep_args_input = picker:_get_prompt()
          end

          require("telescope").extensions.live_grep_args.live_grep_args({
            default_text = vim.g.last_grep_args_input or '"" --glob ""',
            entry_maker = grep_entry_maker(),
            attach_mappings = function(prompt_bufnr, map)
              map("i", "<Esc>", function()
                save_input(prompt_bufnr)
                actions.close(prompt_bufnr)
              end)
              map("i", "<C-c>", function()
                save_input(prompt_bufnr)
                actions.close(prompt_bufnr)
              end)
              map("i", "<CR>", function()
                save_input(prompt_bufnr)
                actions.select_default(prompt_bufnr)
              end)
              return true
            end,
          })
        end,
        desc = "Live grep with args",
      },
      {
        "<leader>tr",
        function()
          local pattern = vim.g.last_grep_pattern or ""
          local cmd = ":noautocmd cfdo %s/" .. pattern .. "//g | update"
          -- カーソルを置換文字列の位置に（/g | update の前）
          local left = string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 11)
          vim.api.nvim_feedkeys(cmd .. left, "n", false)
        end,
        desc = "Replace in quickfix",
      },
      {
        "<leader>tp",
        function()
          require("telescope.builtin").find_files({
            -- 散らばった文字でもマッチする fuzzy をやめ、部分文字列の完全一致にする
            -- （スペース区切りで AND、^ $ ! などの fzf 記法は使用可）
            sorter = require("telescope").extensions.fzf.native_fzf_sorter({
              fuzzy = false,
              case_mode = "ignore_case",
            }),
            attach_mappings = function(prompt_bufnr)
              -- この picker だけマッチ文字のオレンジ表示を有効化する
              vim.schedule(function()
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                if picker and picker.results_win and vim.api.nvim_win_is_valid(picker.results_win) then
                  -- 上書きすると telescope の背景設定が消えるため既存の winhighlight に追記する
                  local winhl = vim.wo[picker.results_win].winhighlight
                  vim.wo[picker.results_win].winhighlight = (winhl ~= "" and winhl .. "," or "")
                    .. "TelescopeMatching:TelescopeMatchingActive"
                end
              end)
              return true
            end,
          })
        end,
        desc = "Find files",
      },
      {
        "<leader>tc",
        function() require("telescope.builtin").commands() end,
        desc = "Commands",
      },
      {
        "<leader>tf",
        function()
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local save_input = function(prompt_bufnr)
            local picker = action_state.get_current_picker(prompt_bufnr)
            vim.g.last_live_grep_input = picker:_get_prompt()
          end

          require("telescope.builtin").live_grep({
            default_text = vim.g.last_live_grep_input or "",
            entry_maker = grep_entry_maker(),
            attach_mappings = function(prompt_bufnr, map)
              map("i", "<Esc>", function()
                save_input(prompt_bufnr)
                actions.close(prompt_bufnr)
              end)
              map("i", "<C-c>", function()
                save_input(prompt_bufnr)
                actions.close(prompt_bufnr)
              end)
              return true
            end,
          })
        end,
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
      -- Status Text: show match count and file count
      --------------------------------------------------------------------------

      local function count_unique_files(picker)
        if not picker.manager then
          return 0
        end
        local seen = {}
        local count = 0
        for entry in picker.manager:iter() do
          local fname = entry.filename or (type(entry.value) == "string" and entry.value) or nil
          if fname and not seen[fname] then
            seen[fname] = true
            count = count + 1
          end
        end
        return count
      end

      local function custom_get_status_text(self, opts)
        local strings = require("plenary.strings")
        local showing_cnt = (self.stats.processed or 0) - (self.stats.filtered or 0)
        local total_cnt = self.stats.processed or 0
        local multi_select_cnt = #(self:get_multi_selection())

        local status_icon = (opts and not opts.completed) and "* " or ""

        if showing_cnt == 0 and total_cnt == 0 then
          return status_icon
        end

        local file_count = count_unique_files(self)

        local status_text
        if multi_select_cnt > 0 then
          status_text = string.format("%s%d sel / %d (%d files) / %d", status_icon, multi_select_cnt, showing_cnt, file_count, total_cnt)
        else
          status_text = string.format("%s%d (%d files) / %d", status_icon, showing_cnt, file_count, total_cnt)
        end

        local prompt_width = vim.api.nvim_win_get_width(self.prompt_win)
        local cursor_col = vim.api.nvim_win_get_cursor(self.prompt_win)[2]
        local prefix_display_width = strings.strdisplaywidth(self.prompt_prefix)
        local prefix_width = #self.prompt_prefix
        local prefix_shift = 0
        if prefix_display_width ~= prefix_width then
          prefix_shift = prefix_display_width
        end

        if (prompt_width - cursor_col - #status_text + prefix_shift) < 0 then
          return ""
        end
        return status_text
      end

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
        "%.git/",

        -- Build outputs
        "/dist/",
        "/build/",
        "/out/",
        "/target/",

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
          get_status_text = custom_get_status_text,
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
              ["<C-q>"] = function(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local picker = action_state.get_current_picker(prompt_bufnr)
                local prompt = picker:_get_prompt()
                -- live_grep_args: '"pattern" --glob ...' → pattern を抽出
                local pattern = prompt:match('^"([^"]*)"') or prompt:match("^([^%s]+)") or prompt
                vim.g.last_grep_pattern = pattern
                actions.send_to_qflist(prompt_bufnr)
                actions.open_qflist(prompt_bufnr)
              end,
            },
          },
          file_ignore_patterns = exclude_patterns,
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = { "--hidden" },
            only_sort_text = true, -- ファイル名を照合対象にせず行テキストのみマッチさせる
          },
          grep_string = {
            additional_args = { "--hidden" },
            only_sort_text = true,
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
            case_mode = "ignore_case",
          },
        },
      })

      -- Results 内のマッチ文字ハイライト（オレンジ表示）は既定で無効化する。
      -- 有効にしたい picker では winhighlight で TelescopeMatchingActive に差し替える
      local setup_matching_hl = function()
        vim.api.nvim_set_hl(0, "TelescopeMatching", {})
        vim.api.nvim_set_hl(0, "TelescopeMatchingActive", { fg = "#fe8019" })
      end
      setup_matching_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_matching_hl })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "live_grep_args")
    end,
  },
}
