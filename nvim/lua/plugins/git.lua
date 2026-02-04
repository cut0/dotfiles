return {
  -- Git diff ビューア
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "Branch History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>",         desc = "Diffview Close" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        win_config = {
          position = "left",
          width = 35,
        },
      },
    },
  },
  -- Git コミットメッセージ表示
  {
    "rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    keys = {
      { "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Git Messenger" },
    },
    init = function()
      vim.g.git_messenger_floating_win_opts = { border = "rounded" }
      vim.g.git_messenger_no_default_mappings = true
      vim.g.git_messenger_always_into_popup = true
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "▔" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        signs_staged = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "▔" },
          changedelete = { text = "▎" },
        },
        current_line_blame = false,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })
        end,
      })
    end,
  },
  -- GitHub URL 生成
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Copy git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
      { "<leader>go", "<cmd>GitLink! current_branch<cr>", mode = { "n", "v" }, desc = "Open (current branch)" },
      { "<leader>gB", "<cmd>GitLink blame<cr>", mode = { "n", "v" }, desc = "Copy blame link" },
      {
        "<leader>gO",
        function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local result = vim.system({ "git", "branch", "-r", "--format=%(refname:short)" }, { text = true }):wait()
          if result.code ~= 0 then
            vim.notify("Failed to get branches", vim.log.levels.ERROR)
            return
          end

          local branches = {}
          for branch in result.stdout:gmatch("[^\n]+") do
            local clean = branch:gsub("^origin/", "")
            if clean ~= "HEAD" then
              table.insert(branches, clean)
            end
          end

          pickers
            .new({}, {
              prompt_title = "Select Branch",
              finder = finders.new_table({ results = branches }),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  if selection then
                    vim.cmd("GitLink! rev=" .. selection[1])
                  end
                end)
                return true
              end,
            })
            :find()
        end,
        mode = { "n", "v" },
        desc = "Open (select branch)",
      },
    },
    opts = {},
  },
  -- Git blame 表示
  {
    "APZelos/blamer.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>gb", "<cmd>BlamerToggle<cr>", desc = "Toggle Git Blame" },
    },
    init = function()
      vim.g.blamer_enabled = 1
      vim.g.blamer_delay = 500
      vim.g.blamer_show_in_insert_modes = 0
      vim.g.blamer_show_in_visual_modes = 0
      vim.g.blamer_prefix = "  "
      vim.g.blamer_template = "<committer> • <committer-time> • <summary>"
      vim.g.blamer_date_format = "%Y-%m-%d"
      vim.g.blamer_relative_time = 1
    end,
  },
}
