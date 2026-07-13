return {
  {
    "dnlhc/glance.nvim",
    commit = "bf86d8b79dce808e65fdb6e9269d0b4ed6d2eefc",
    cmd = "Glance",
    opts = {
      hooks = {
        -- 現在ファイルの参照は候補から除外する
        before_open = function(results, open, _, method)
          if method ~= "references" then
            open(results)
            return
          end

          local current_uri = vim.uri_from_bufnr(0)
          local filtered = vim.tbl_filter(function(location)
            local uri = location.uri or location.targetUri
            return uri ~= current_uri
          end, results)

          if vim.tbl_isempty(filtered) then
            vim.notify("No references found", vim.log.levels.INFO)
            return
          end
          open(filtered)
        end,
      },
    },
  },
}
