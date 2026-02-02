-- WezTerm キーバインド設定
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

--------------------------------------------------------------------------------
-- Keys
--------------------------------------------------------------------------------

local keys = {
  -- Toggle Split/Zoom: Cmd+M
  -- 1ペインの場合: 縦に分割 + 下ペインを2列に
  -- 複数ペインの場合: 上ペインをズーム/解除時は下左にフォーカス
  {
    key = "m",
    mods = "SUPER",
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      local panes_with_info = tab:panes_with_info()

      if #panes_with_info == 1 then
        -- 1ペインのみ: 縦に分割し、下のペインをさらに2列に
        local bottom_left = pane:split({ direction = "Bottom" })
        bottom_left:split({ direction = "Right" })
        -- 2行目1列目（左下）にフォーカス
        bottom_left:activate()
      else
        -- 現在ズーム中かどうか確認
        local is_zoomed = panes_with_info[1].is_zoomed

        -- 1行目（top最小）と2行目1列目（top最大かつleft最小）を特定
        local top_pane = panes_with_info[1]
        local bottom_left_pane = nil

        for _, p in ipairs(panes_with_info) do
          if p.top < top_pane.top then
            top_pane = p
          end
          if bottom_left_pane == nil or p.top > bottom_left_pane.top or
             (p.top == bottom_left_pane.top and p.left < bottom_left_pane.left) then
            bottom_left_pane = p
          end
        end

        if is_zoomed then
          -- ズーム解除して2行目1列目にフォーカス
          window:perform_action(act.TogglePaneZoomState, pane)
          bottom_left_pane.pane:activate()
        else
          -- 1行目をズーム
          top_pane.pane:activate()
          window:perform_action(act.TogglePaneZoomState, top_pane.pane)
        end
      end
    end),
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

  -- Window Management
  { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "w", mods = "SUPER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "q", mods = "SUPER", action = act.QuitApplication },
  { key = "\\", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  -- Pane Navigation
  { key = "LeftArrow", mods = "SUPER", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "SUPER", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "SUPER", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "SUPER", action = act.ActivatePaneDirection("Down") },

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
