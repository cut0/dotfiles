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

  -- ターゲットウィンドウに開くカスタムアクション（別ファイルの場合のみ）
  local function make_lsp_picker_with_target_window(picker_fn, picker_opts)
    return function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local current_file = vim.api.nvim_buf_get_name(0)

      picker_fn(vim.tbl_extend("force", picker_opts or {}, {
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if entry.filename ~= current_file then
              utils.open_in_target_window(entry.filename, entry.lnum, entry.col)
            else
              vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
            end
          end)
          return true
        end,
      }))
    end
  end

  -- 定義・参照ジャンプ
  keymap("n", "<leader>i", make_lsp_picker_with_target_window(telescope.lsp_implementations, { jump_type = "never" }), opts("Go to implementation"))
  keymap("n", "<leader><CR>", make_lsp_picker_with_target_window(telescope.lsp_definitions, { jump_type = "never" }), opts("Go to definition"))
  keymap("n", "<leader><S-CR>", "<cmd>Glance references<cr>", opts("Show references (Glance)"))
  keymap("n", "<leader><A-CR>", make_lsp_picker_with_target_window(telescope.lsp_type_definitions, { jump_type = "never" }), opts("Go to type definition"))

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
  setup_attach_handler()
  setup_diagnostics()
end

return M
