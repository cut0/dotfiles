-- WezTerm Configuration
local wezterm = require("wezterm")
local keys = require("keys")
local key_tables = require("key_tables")
local appearance = require("appearance")

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

wezterm.on("format-tab-title", function(tab, tabs)
  -- ディレクトリ名を取得
  local cwd_uri = tab.active_pane.current_working_dir
  local dir_name = "~"
  if cwd_uri then
    local cwd = cwd_uri.file_path or tostring(cwd_uri)
    dir_name = cwd:match("([^/]+)/?$") or "~"
  end

  local index = tab.tab_index + 1
  local title = "  " .. index .. ": " .. dir_name .. "  "

  local is_active = tab.is_active
  local bg = is_active and "#d65d0e" or "#141617"
  local fg = is_active and "#ebdbb2" or "#928374"

  local SOLID_RIGHT = utf8.char(0xe0b0)

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = title },
    { Background = { Color = "#141617" } },
    { Foreground = { Color = bg } },
    { Text = SOLID_RIGHT },
    { Background = { Color = "#141617" } },
    { Foreground = { Color = "#141617" } },
    { Text = " " },
  }
end)

--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------

local config = {
  automatically_reload_config = true,
  use_ime = true,
  term = "wezterm",
  disable_default_key_bindings = true,

  keys = keys.get_keys(),
  key_tables = key_tables,
}

-- Merge appearance settings
for k, v in pairs(appearance) do
  config[k] = v
end

return config
