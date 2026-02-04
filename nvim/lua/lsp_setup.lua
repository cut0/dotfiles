local M = {}
local utils = require("utils")

--------------------------------------------------------------------------------
-- LSP Keymaps (buffer-local)
--------------------------------------------------------------------------------

local function setup_lsp_keymaps(bufnr)
  local opts = function(desc)
    return { buffer = bufnr, noremap = true, silent = true, desc = desc }
  end

  local keymap = vim.keymap.set
  local telescope = require("telescope.builtin")

  -- 参照を表示（同一ファイルは全参照、他ファイルはファイル単位で重複除去）
  local function lsp_references_unique_files()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local entry_display = require("telescope.pickers.entry_display")
    local previewers = require("telescope.previewers")

    local client = vim.lsp.get_clients({ bufnr = 0 })[1]
    local params = vim.lsp.util.make_position_params(0, client and client.offset_encoding or "utf-16")
    ---@diagnostic disable-next-line: inject-field
    params.context = { includeDeclaration = true }

    local current_file = vim.api.nvim_buf_get_name(0)
    local symbol_name = vim.fn.expand("<cword>")

    vim.lsp.buf_request(0, "textDocument/references", params, function(err, result)
      if err or not result or vim.tbl_isempty(result) then
        vim.notify("No references found", vim.log.levels.INFO)
        return
      end

      -- 同一ファイルは全参照、他ファイルは重複除去
      local seen_files = {}
      local entries = {}
      for _, ref in ipairs(result) do
        local uri = ref.uri or ref.targetUri
        if uri then
          local filepath = vim.uri_to_fname(uri)
          local is_current = filepath == current_file

          if is_current or not seen_files[uri] then
            if not is_current then
              seen_files[uri] = true
            end
            table.insert(entries, {
              filepath = filepath,
              lnum = ref.range.start.line + 1,
              col = ref.range.start.character + 1,
              is_current = is_current,
            })
          end
        end
      end

      -- プロジェクトルートを取得
      local root = vim.fs.root(0, { ".git", "package.json", "go.mod", "Cargo.toml" }) or vim.fn.getcwd()

      local displayer = entry_display.create({
        separator = " ",
        items = {
          { remaining = true },
        },
      })

      local make_display = function(entry)
        local filepath = entry.value.filepath
        -- プロジェクトルートからの相対パスに変換
        if filepath:sub(1, #root) == root then
          filepath = filepath:sub(#root + 2)
        end

        local display_text = filepath
        if entry.value.is_current then
          display_text = filepath .. ":" .. entry.value.lnum
        end

        -- 同一ファイル内は別の色で表示
        local hl = entry.value.is_current and "TelescopeResultsComment" or nil
        return displayer({ { display_text, hl } })
      end

      -- オレンジ背景のハイライトグループを定義
      vim.api.nvim_set_hl(0, "TelescopePreviewMatch", { bg = "#fe8019", fg = "#282828" })

      -- カスタム previewer（シンボルをハイライト）
      local custom_previewer = previewers.new_buffer_previewer({
        title = "Preview",
        define_preview = function(self, entry, _)
          conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
            bufname = self.state.bufname,
            winid = self.state.winid,
            callback = function(preview_bufnr)
              -- プレビューバッファにジャンプ位置を設定
              pcall(vim.api.nvim_win_set_cursor, self.state.winid, { entry.lnum, entry.col - 1 })

              -- シンボル名をハイライト
              if symbol_name and #symbol_name > 0 then
                local line = vim.api.nvim_buf_get_lines(preview_bufnr, entry.lnum - 1, entry.lnum, false)[1]
                if line then
                  local col_start = entry.col - 1
                  local col_end = col_start + #symbol_name
                  pcall(vim.api.nvim_buf_set_extmark, preview_bufnr, vim.api.nvim_create_namespace("lsp_preview_highlight"), entry.lnum - 1, col_start, {
                    end_col = col_end,
                    hl_group = "TelescopePreviewMatch",
                  })
                end
              end
            end,
          })
        end,
      })

      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      pickers.new({}, {
        prompt_title = "References",
        finder = finders.new_table({
          results = entries,
          entry_maker = function(entry)
            return {
              value = entry,
              display = make_display,
              ordinal = entry.filepath .. ":" .. entry.lnum,
              filename = entry.filepath,
              lnum = entry.lnum,
              col = entry.col,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = custom_previewer,
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            utils.open_in_target_window(entry.filename, entry.lnum, entry.col)
          end)
          return true
        end,
      }):find()
    end)
  end

  -- ターゲットウィンドウに開くカスタムアクション
  local function make_lsp_picker_with_target_window(picker_fn, picker_opts)
    return function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      picker_fn(vim.tbl_extend("force", picker_opts or {}, {
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            utils.open_in_target_window(entry.filename, entry.lnum, entry.col)
          end)
          return true
        end,
      }))
    end
  end

  -- 定義・参照ジャンプ
  keymap("n", "<leader>i", make_lsp_picker_with_target_window(telescope.lsp_implementations), opts("Go to implementation"))
  keymap("n", "<leader><CR>", make_lsp_picker_with_target_window(telescope.lsp_definitions), opts("Go to definition"))
  keymap("n", "<leader><S-CR>", lsp_references_unique_files, opts("Show references (unique files)"))
  keymap("n", "<leader><A-CR>", make_lsp_picker_with_target_window(telescope.lsp_type_definitions), opts("Go to type definition"))

  -- リネーム
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))

  -- コードアクション
  keymap("n", "<leader>.", vim.lsp.buf.code_action, opts("Quick fix / Code action"))

  -- ホバー / 診断表示
  keymap("n", "K", function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
    if #diagnostics > 0 then
      vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    else
      vim.lsp.buf.hover()
    end
  end, opts("Show diagnostics or hover"))

  -- シンボル検索
  keymap("n", "<leader>o", telescope.lsp_document_symbols, opts("Document symbols"))
  keymap("n", "<leader>s", telescope.lsp_workspace_symbols, opts("Workspace symbols"))

  -- 診断ナビゲーション
  keymap("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, opts("Previous diagnostic"))
  keymap("n", "]g", function() vim.diagnostic.jump({ count = 1 }) end, opts("Next diagnostic"))
  keymap("n", "<leader>q", vim.diagnostic.setloclist, opts("Diagnostic list"))
end

--------------------------------------------------------------------------------
-- LSP Server Configuration
--------------------------------------------------------------------------------

local function setup_servers()
  vim.lsp.config("*", {
    root_markers = { ".git" },
  })

  vim.lsp.enable({
    "ts_ls",
    "denols",
    "biome",
    "gopls",
    "lua_ls",
    "eslint",
  })
end

--------------------------------------------------------------------------------
-- LSP Attach Handler
--------------------------------------------------------------------------------

local function setup_attach_handler()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      setup_lsp_keymaps(ev.buf)

      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      -- Deno プロジェクトでは ts_ls を停止
      if client and client.name == "ts_ls" then
        local root_dir = client.config.root_dir
        if root_dir then
          local deno_json = vim.fs.find({ "deno.json", "deno.jsonc" }, { path = root_dir, upward = false })
          if #deno_json > 0 then
            client:stop()
          end
        end
      end

      -- カーソル位置のシンボルをハイライト
      if client and client:supports_method("textDocument/documentHighlight", { bufnr = ev.buf }) then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = ev.buf,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = ev.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
end

--------------------------------------------------------------------------------
-- Diagnostic Configuration
--------------------------------------------------------------------------------

local function setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      source = "if_many",
    },
    float = {
      border = "rounded",
      source = true,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = "󰌵 ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function M.setup()
  setup_servers()
  setup_attach_handler()
  setup_diagnostics()
end

return M
