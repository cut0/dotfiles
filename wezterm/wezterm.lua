-- WezTerm Configuration
local wezterm = require("wezterm")
local keys = require("keys")
local key_tables = require("key_tables")
local appearance = require("appearance")

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

wezterm.on("format-tab-title", function(tab)
  local title = tab.active_pane.title
  return "  " .. title .. "  "
end)

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  pane:split({ direction = "Right" })
end)

--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------

local config = {
  automatically_reload_config = true,
  use_ime = true,
  disable_default_key_bindings = true,
  keys = keys.get_keys(),
  key_tables = key_tables,
}

-- Merge appearance settings
for k, v in pairs(appearance) do
  config[k] = v
end

return config
