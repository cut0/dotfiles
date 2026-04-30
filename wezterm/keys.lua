-- WezTerm キーバインド設定
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

-- 1ペインから cols x rows のグリッドを均等サイズで構築
local function build_grid(tab, cols, rows)
  local col_panes = { tab:panes_with_info()[1].pane }
  for i = 1, cols - 1 do
    local size = (cols - i) / (cols - i + 1)
    local new_pane = col_panes[#col_panes]:split({ direction = "Right", size = size })
    table.insert(col_panes, new_pane)
  end

  local all_panes = {}
  for _, cp in ipairs(col_panes) do
    local current = cp
    table.insert(all_panes, current)
    for i = 1, rows - 1 do
      local size = (rows - i) / (rows - i + 1)
      current = current:split({ direction = "Bottom", size = size })
      table.insert(all_panes, current)
    end
  end

  return all_panes
end

-- タブ内のペインを全て閉じて1ペインに戻す
local function collapse_to_single(window, tab)
  while #tab:panes_with_info() > 1 do
    local ps = tab:panes_with_info()
    ps[#ps].pane:activate()
    window:perform_action(act.CloseCurrentPane({ confirm = false }), ps[#ps].pane)
  end
end

-- 既存のペインを保ったまま、サイズだけ均等化（n×m グリッド構造を仮定）
--
-- 重要な前提:
--   AdjustPaneSize で境界を動かすと、隣接する列・行のペインは比率を維持したまま
--   再分配される。つまり初期スナップショットから計算した累積差分は正しくない。
--   そのため各ステップ直前に panes_with_info() を取り直し、現在の境界位置と
--   目標絶対位置の差分を再計算する。
--
-- 設計方針:
--   1. 初回ループで画面サイズ・列数/行数・元アクティブペインを取得
--   2. 目標サイズ = floor(画面サイズ / ペイン数)
--   3. 列 i の右境界 → 絶対位置 i * target_w に動的調整（adjust_col 再帰）
--   4. 行 i の下境界 → 絶対位置 i * target_h に動的調整（adjust_row 再帰）
--   5. 全完了後に元アクティブペインへ戻す
--   各ステップ間は wezterm.time.call_after で 1ms の極小遅延
--   （AdjustPaneSize の効果が反映されるまでのラグを吸収するためで、視覚的影響は最小）
local function equalize_panes(window)
  local tab = window:active_tab()
  local panes = tab:panes_with_info()
  if #panes <= 1 then
    return
  end

  ----------------------------------------------------------------------------
  -- (1) 画面サイズと初期構造の取得（1 回だけ）
  ----------------------------------------------------------------------------
  local screen_w, screen_h = 0, 0
  local seen_left, seen_top = {}, {}
  local num_cols, num_rows = 0, 0
  local active_pane

  for _, p in ipairs(panes) do
    screen_w = math.max(screen_w, p.left + p.width)
    screen_h = math.max(screen_h, p.top + p.height)
    if not seen_left[p.left] then
      seen_left[p.left] = true
      num_cols = num_cols + 1
    end
    if not seen_top[p.top] then
      seen_top[p.top] = true
      num_rows = num_rows + 1
    end
    if p.is_active then
      active_pane = p.pane
    end
  end

  ----------------------------------------------------------------------------
  -- (2) 目標サイズ算出
  ----------------------------------------------------------------------------
  local target_w = math.floor(screen_w / num_cols)
  local target_h = math.floor(screen_h / num_rows)

  ----------------------------------------------------------------------------
  -- (3) 1 境界ずつ「現在位置と目標絶対位置の差分」を取って動かす
  --     各ステップ直前に panes_with_info を再取得することで、前ステップの
  --     再分配を踏まえた正確な delta を得る
  ----------------------------------------------------------------------------
  local DELAY = 0.001

  local function pick_rep_at_left(cur_panes, left)
    for _, p in ipairs(cur_panes) do
      if p.left == left then
        return p
      end
    end
  end

  local function sorted_unique_lefts(cur_panes)
    local seen, lefts = {}, {}
    for _, p in ipairs(cur_panes) do
      if not seen[p.left] then
        seen[p.left] = true
        table.insert(lefts, p.left)
      end
    end
    table.sort(lefts)
    return lefts
  end

  local function adjust_col(i, on_done)
    if i > num_cols - 1 then
      on_done()
      return
    end
    local cur = window:active_tab():panes_with_info()
    local lefts = sorted_unique_lefts(cur)
    local rep = pick_rep_at_left(cur, lefts[i])
    if not rep then
      adjust_col(i + 1, on_done)
      return
    end

    local current_right = rep.left + rep.width
    local target_right = i * target_w
    local delta = target_right - current_right

    if delta == 0 then
      adjust_col(i + 1, on_done)
      return
    end

    rep.pane:activate()
    wezterm.time.call_after(DELAY, function()
      local dir = delta > 0 and "Right" or "Left"
      window:perform_action(act.AdjustPaneSize({ dir, math.abs(delta) }), rep.pane)
      wezterm.time.call_after(DELAY, function()
        adjust_col(i + 1, on_done)
      end)
    end)
  end

  -- 行調整は列ごとに独立して行う必要がある（build_grid のツリー構造上、
  -- 各列が独立した SplitV を持つため、ある列の AdjustPaneSize{Down,..} は
  -- その列の行境界しか動かさない）
  local function adjust_row_in_col(col_idx, row_idx, on_done)
    if col_idx > num_cols then
      on_done()
      return
    end
    if row_idx > num_rows - 1 then
      adjust_row_in_col(col_idx + 1, 1, on_done)
      return
    end

    local cur = window:active_tab():panes_with_info()
    local lefts = sorted_unique_lefts(cur)
    local target_left = lefts[col_idx]

    -- 対象列のペインを top 順にソート
    local col_panes = {}
    for _, p in ipairs(cur) do
      if p.left == target_left then
        table.insert(col_panes, p)
      end
    end
    table.sort(col_panes, function(a, b)
      return a.top < b.top
    end)

    local rep = col_panes[row_idx]
    if not rep then
      adjust_row_in_col(col_idx, row_idx + 1, on_done)
      return
    end

    local current_bottom = rep.top + rep.height
    local target_bottom = row_idx * target_h
    local delta = target_bottom - current_bottom

    if delta == 0 then
      adjust_row_in_col(col_idx, row_idx + 1, on_done)
      return
    end

    rep.pane:activate()
    wezterm.time.call_after(DELAY, function()
      local dir = delta > 0 and "Down" or "Up"
      window:perform_action(act.AdjustPaneSize({ dir, math.abs(delta) }), rep.pane)
      wezterm.time.call_after(DELAY, function()
        adjust_row_in_col(col_idx, row_idx + 1, on_done)
      end)
    end)
  end

  ----------------------------------------------------------------------------
  -- (4) 列 → 行（列ごとに独立）の順に調整、最後に元アクティブペインへ戻す
  ----------------------------------------------------------------------------
  adjust_col(1, function()
    adjust_row_in_col(1, 1, function()
      if active_pane then
        active_pane:activate()
      end
    end)
  end)
end

--------------------------------------------------------------------------------
-- Keys
--------------------------------------------------------------------------------

local keys = {
  -- Zoom Toggle: Cmd+M
  { key = "m", mods = "SUPER", action = act.TogglePaneZoomState },

  -- Equalize Panes: Cmd+Shift+E
  -- 現在の n×m レイアウトのサイズだけを均等化（ペイン内容は保持）
  {
    key = "e",
    mods = "SUPER|SHIFT",
    action = wezterm.action_callback(function(window, _pane)
      equalize_panes(window)
    end),
  },

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
        { label = "3x3 (3列3行)", id = "3x3" },
        { label = "4x2 (4列2行)", id = "4x2" },
        { label = "4x4 (4列4行)", id = "4x4" },
      },
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id then
          return
        end

        if id == "equalize" then
          equalize_panes(window)
          return
        end

        local cols, rows = id:match("^(%d+)x(%d+)$")
        cols, rows = tonumber(cols), tonumber(rows)

        local tab = window:active_tab()
        collapse_to_single(window, tab)
        build_grid(tab, cols, rows)
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

  -- Copy Mode
  { key = "j", mods = "SUPER", action = act.ActivateCopyMode },

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

  -- QuickSelect: Cmd+Shift+C で汎用 (URL/パス/ハッシュ等) をコピー
  { key = "C", mods = "SUPER|SHIFT", action = act.QuickSelect },

  -- QuickSelect: Cmd+Shift+O で URL をブラウザで開く
  {
    key = "O",
    mods = "SUPER|SHIFT",
    action = act.QuickSelectArgs({
      patterns = { "https?://\\S+" },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        if url and url ~= "" then
          wezterm.open_with(url)
        end
      end),
    }),
  },
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------

function M.get_keys()
  return keys
end

return M
