local M = {}

--------------------------------------------------------------------------------
-- LSP Keymaps (buffer-local)
--------------------------------------------------------------------------------

local function setup_lsp_keymaps(bufnr)
  local opts = function(desc)
    return { buffer = bufnr, noremap = true, silent = true, desc = desc }
  end

  local keymap = vim.keymap.set
  local telescope = require("telescope.builtin")

  -- 定義・参照ジャンプ (Leader key)
  keymap("n", "<leader>i", telescope.lsp_implementations, opts("Go to implementation"))

  -- 定義・参照ジャンプ (Cmd key via WezTerm)
  keymap("n", "<M-CR>", telescope.lsp_definitions, opts("Go to definition"))
  keymap("n", "<M-C-CR>", telescope.lsp_type_definitions, opts("Go to type definition"))
  keymap("n", "<M-S-CR>", telescope.lsp_references, opts("Show references"))

  -- リネーム
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))

  -- コードアクション
  keymap("n", "<M-.>", vim.lsp.buf.code_action, opts("Quick fix / Code action"))

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
      if client and client.supports_method("textDocument/documentHighlight") then
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
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
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
