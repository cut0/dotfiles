--------------------------------------------------------------------------------
-- Buffer Tracking (開いた時刻・順序を記録)
--------------------------------------------------------------------------------

_G.buffer_open_times = _G.buffer_open_times or {}
_G.buffer_open_order = _G.buffer_open_order or {}
_G.buffer_open_counter = _G.buffer_open_counter or 0

vim.api.nvim_create_autocmd("BufAdd", {
  group = vim.api.nvim_create_augroup("BufferTracking", { clear = true }),
  callback = function(args)
    _G.buffer_open_counter = _G.buffer_open_counter + 1
    _G.buffer_open_times[args.buf] = vim.fn.strftime("%H:%M:%S")
    _G.buffer_open_order[args.buf] = _G.buffer_open_counter
  end,
})

--------------------------------------------------------------------------------
-- Closed Buffer Stack (復元用)
--------------------------------------------------------------------------------

local closed_buffers = {}
local max_closed_buffers = 20

local function push_closed_buffer(filepath)
  if filepath and filepath ~= "" then
    table.insert(closed_buffers, filepath)
    if #closed_buffers > max_closed_buffers then
      table.remove(closed_buffers, 1)
    end
  end
end

local function pop_closed_buffer()
  if #closed_buffers > 0 then
    return table.remove(closed_buffers)
  end
  return nil
end

return {
  {
    "echasnovski/mini.bufremove",
    version = "*",
    keys = {
      {
        "<leader>x",
        function()
          local win_count = #vim.api.nvim_list_wins()
          local current_buf = vim.api.nvim_get_current_buf()
          local buf_name = vim.api.nvim_buf_get_name(current_buf)
          local buf_modified = vim.bo[current_buf].modified
          local bufs = vim.fn.getbufinfo({ buflisted = 1 })

          local is_empty = buf_name == "" and not buf_modified

          -- 閉じる前にパスを記録
          if buf_name ~= "" then
            push_closed_buffer(buf_name)
          end

          if (is_empty or #bufs <= 1) and win_count > 1 then
            vim.cmd("close")
          else
            require("mini.bufremove").delete(0, false)
          end
        end,
        desc = "Close current buffer",
      },
      {
        "<leader>u",
        function()
          local filepath = pop_closed_buffer()
          if filepath then
            vim.cmd("edit " .. vim.fn.fnameescape(filepath))
          else
            vim.notify("No closed buffer to restore", vim.log.levels.INFO)
          end
        end,
        desc = "Restore closed buffer",
      },
      {
        "<leader>X",
        function()
          vim.cmd("only")
          vim.cmd("%bdelete")
          vim.cmd("enew")
          -- バッファ追跡情報をリセット
          _G.buffer_open_times = {}
          _G.buffer_open_order = {}
          _G.buffer_open_counter = 0
        end,
        desc = "Close all and reset buffers",
      },
    },
    config = function()
      require("mini.bufremove").setup({})
    end,
  },
}
