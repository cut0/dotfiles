-- WezTerm キーバインド設定
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

--------------------------------------------------------------------------------
-- Keys
--------------------------------------------------------------------------------

local keys = {
  -- Zoom Toggle: Cmd+M
  { key = "m", mods = "SUPER", action = act.TogglePaneZoomState },

  -- Grid Split: Cmd+Shift+G
  -- 選択式グリッドレイアウト
  {
    key = "g",
    mods = "SUPER|SHIFT",
    action = act.InputSelector({
      title = "Grid Layout",
      choices = {
        { label = "均等配置 (Equalize)", id = "equalize" },
        { label = "2x1 (2列1行)", id = "2x1" },
        { label = "2x2 (2列2行)", id = "2x2" },
        { label = "4x2 (4列2行)", id = "4x2" },
        { label = "4x4 (4列4行)", id = "4x4" },
      },
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id then
          return
        end

        -- 均等配置: cwdを保持しつつ均等サイズで再分割
        if id == "equalize" then
          local tab = window:active_tab()
          local panes = tab:panes_with_info()
          local total = #panes
          if total <= 1 then
            return
          end

          -- 現在のグリッド構造を推定（列数・行数）
          local col_set, row_set = {}, {}
          for _, p in ipairs(panes) do
            col_set[p.left] = true
            row_set[p.top] = true
          end
          local num_cols, num_rows = 0, 0
          for _ in pairs(col_set) do
            num_cols = num_cols + 1
          end
          for _ in pairs(row_set) do
            num_rows = num_rows + 1
          end

          -- ペインを位置順にソートしてcwdを保存
          table.sort(panes, function(a, b)
            if a.top ~= b.top then
              return a.top < b.top
            end
            return a.left < b.left
          end)
          local cwds = {}
          for _, p in ipairs(panes) do
            local cwd = p.pane:get_current_working_dir()
            table.insert(cwds, cwd and cwd.file_path or nil)
          end

          -- 全ペインを閉じて1つにする
          while #tab:panes_with_info() > 1 do
            local ps = tab:panes_with_info()
            ps[#ps].pane:activate()
            window:perform_action(act.CloseCurrentPane({ confirm = false }), ps[#ps].pane)
          end

          -- 列を作成（均等サイズ）
          local col_panes = { tab:panes_with_info()[1].pane }
          for i = 1, num_cols - 1 do
            local size = (num_cols - i) / (num_cols - i + 1)
            local new_pane = col_panes[#col_panes]:split({ direction = "Right", size = size })
            table.insert(col_panes, new_pane)
          end

          -- 各列を行に分割（均等サイズ）
          local all_panes = {}
          for col_idx, cp in ipairs(col_panes) do
            local current = cp
            table.insert(all_panes, current)
            for i = 1, num_rows - 1 do
              local size = (num_rows - i) / (num_rows - i + 1)
              current = current:split({ direction = "Bottom", size = size })
              table.insert(all_panes, current)
            end
          end

          -- cwdを復元（各ペインでcdを送信）
          for i, p in ipairs(all_panes) do
            if cwds[i] then
              p:send_text("cd " .. wezterm.shell_quote_arg(cwds[i]) .. " && clear\n")
            end
          end

          -- 左上ペインにフォーカス
          all_panes[1]:activate()
          return
        end

        local cols, rows = id:match("^(%d+)x(%d+)$")
        cols, rows = tonumber(cols), tonumber(rows)

        -- 既存ペインを全て閉じて1ペインにする
        local tab = window:active_tab()
        while #tab:panes_with_info() > 1 do
          local panes = tab:panes_with_info()
          panes[#panes].pane:activate()
          window:perform_action(act.CloseCurrentPane({ confirm = false }), panes[#panes].pane)
        end

        -- 列を作成（cols - 1 回 Right 分割、均等サイズ）
        local col_panes = { tab:panes_with_info()[1].pane }
        for i = 1, cols - 1 do
          local size = (cols - i) / (cols - i + 1)
          local new_pane = col_panes[#col_panes]:split({ direction = "Right", size = size })
          table.insert(col_panes, new_pane)
        end

        -- 各列を行に分割（rows - 1 回 Bottom 分割、均等サイズ）
        for _, cp in ipairs(col_panes) do
          local current = cp
          for i = 1, rows - 1 do
            local size = (rows - i) / (rows - i + 1)
            current = current:split({ direction = "Bottom", size = size })
          end
        end

        -- 左上ペインにフォーカス
        tab:panes_with_info()[1].pane:activate()
      end),
    }),
  },

  -- Font Size
  { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
  { key = "+", mods = "SUPER", action = act.IncreaseFontSize },
  { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
  { key = "0", mods = "SUPER", action = act.ResetFontSize },

  -- Clipboard
  { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

  -- Tabs
  { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "p", mods = "SUPER", action = act.ShowTabNavigator },
  { key = "p", mods = "SUPER|SHIFT", action = act.ShowLauncher },

  -- Broadcast to all panes: Cmd+S
  {
    key = "s",
    mods = "SUPER",
    action = act.PromptInputLine({
      description = "Broadcast command to all panes:",
      action = wezterm.action_callback(function(window, pane, line)
        if not line or line == "" then
          return
        end
        local tab = window:active_tab()
        for _, p in ipairs(tab:panes_with_info()) do
          p.pane:send_text(line .. "\n")
        end
      end),
    }),
  },

  -- Window Management
  { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "w", mods = "SUPER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "q", mods = "SUPER", action = act.QuitApplication },
  { key = "\\", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  -- Scroll
  { key = "UpArrow", mods = "SUPER", action = act.ScrollByLine(-1) },
  { key = "DownArrow", mods = "SUPER", action = act.ScrollByLine(1) },

  -- Pane Navigation
  { key = "LeftArrow", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Down") },

  -- Tab Navigation
  { key = "LeftArrow", mods = "ALT|SUPER", action = act.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = "ALT|SUPER", action = act.ActivateTabRelative(1) },

  -- Search & Reload
  { key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "r", mods = "SUPER", action = act.ReloadConfiguration },
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------

function M.get_keys()
  return keys
end

return M
