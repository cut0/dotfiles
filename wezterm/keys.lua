-- WezTerm キーバインド設定
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

-- Neovim が実行中かどうかを判定
local function is_nvim(pane)
  local process_name = pane:get_foreground_process_name()
  if process_name then
    local name = process_name:match("([^/\\]+)$")
    return name == "nvim" or name == "vim"
  end
  return false
end

-- Neovim 実行時は別のキーを送信、それ以外はデフォルトアクション
local function conditional_key(key, mods, nvim_action, default_action)
  return {
    key = key,
    mods = mods,
    action = wezterm.action_callback(function(window, pane)
      if is_nvim(pane) then
        window:perform_action(nvim_action, pane)
      else
        if default_action then
          window:perform_action(default_action, pane)
        end
      end
    end),
  }
end

-- Neovim にキーを送信
local function send_key_to_nvim(key, mods)
  return act.SendKey({ key = key, mods = mods })
end

--------------------------------------------------------------------------------
-- Neovim Integration Keys (Cmd -> Alt conversion)
--------------------------------------------------------------------------------

local nvim_keys = {
  -- File Tree
  conditional_key("b", "SUPER", send_key_to_nvim("b", "ALT"), nil),
  conditional_key("e", "SUPER|SHIFT", send_key_to_nvim("e", "ALT"), nil),

  -- LSP Navigation
  conditional_key("Return", "SUPER", send_key_to_nvim("Return", "ALT"), nil),
  conditional_key("Return", "SUPER|ALT", send_key_to_nvim("Return", "ALT|CTRL"), nil),
  conditional_key("Return", "SUPER|SHIFT", send_key_to_nvim("Return", "ALT|SHIFT"), nil),

  -- Terminal
  conditional_key("m", "SUPER", send_key_to_nvim("m", "ALT"), act.Hide),

  -- Window Switching (Cmd+1-9)
  conditional_key("1", "SUPER", send_key_to_nvim("1", "ALT"), act.ActivateTab(0)),
  conditional_key("2", "SUPER", send_key_to_nvim("2", "ALT"), act.ActivateTab(1)),
  conditional_key("3", "SUPER", send_key_to_nvim("3", "ALT"), act.ActivateTab(2)),
  conditional_key("4", "SUPER", send_key_to_nvim("4", "ALT"), act.ActivateTab(3)),
  conditional_key("5", "SUPER", send_key_to_nvim("5", "ALT"), act.ActivateTab(4)),
  conditional_key("6", "SUPER", send_key_to_nvim("6", "ALT"), act.ActivateTab(5)),
  conditional_key("7", "SUPER", send_key_to_nvim("7", "ALT"), act.ActivateTab(6)),
  conditional_key("8", "SUPER", send_key_to_nvim("8", "ALT"), act.ActivateTab(7)),
  conditional_key("9", "SUPER", send_key_to_nvim("9", "ALT"), act.ActivateTab(-1)),

  -- Window Management
  conditional_key("\\", "SUPER", send_key_to_nvim("\\", "ALT"), act.SplitHorizontal({ domain = "CurrentPaneDomain" })),
  conditional_key("w", "SUPER", send_key_to_nvim("w", "ALT"), act.CloseCurrentPane({ confirm = true })),
  conditional_key("w", "SUPER|SHIFT", send_key_to_nvim("w", "ALT|SHIFT"), nil),
  conditional_key("q", "SUPER", send_key_to_nvim("q", "ALT"), act.QuitApplication),

  -- Search
  conditional_key("f", "SUPER|SHIFT", send_key_to_nvim("f", "ALT"), nil),
  conditional_key("g", "SUPER|SHIFT", send_key_to_nvim("G", "ALT"), nil),
  conditional_key("p", "SUPER", send_key_to_nvim("p", "ALT"), nil),
  conditional_key("p", "SUPER|SHIFT", send_key_to_nvim("P", "ALT"), nil),

  -- Editor Commands
  conditional_key("s", "SUPER", send_key_to_nvim("s", "ALT"), nil),
  conditional_key("z", "SUPER", send_key_to_nvim("z", "ALT|CTRL"), nil),
  conditional_key("z", "SUPER|SHIFT", send_key_to_nvim("z", "ALT|CTRL|SHIFT"), nil),
  conditional_key("a", "SUPER", send_key_to_nvim("a", "ALT"), nil),

  -- Code Action
  conditional_key(".", "SUPER", send_key_to_nvim(".", "ALT"), nil),

  -- Window Resize
  conditional_key("RightArrow", "CTRL|SHIFT", send_key_to_nvim("RightArrow", "CTRL|SHIFT"), nil),
  conditional_key("LeftArrow", "CTRL|SHIFT", send_key_to_nvim("LeftArrow", "CTRL|SHIFT"), nil),
}

--------------------------------------------------------------------------------
-- Base Keys (Always active)
--------------------------------------------------------------------------------

local base_keys = {
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
  local all_keys = {}
  for _, key in ipairs(nvim_keys) do
    table.insert(all_keys, key)
  end
  for _, key in ipairs(base_keys) do
    table.insert(all_keys, key)
  end
  return all_keys
end

return M
