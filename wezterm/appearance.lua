-- WezTerm Appearance Settings
local wezterm = require("wezterm")

return {
  --------------------------------------------------------------------------------
  -- Font
  --------------------------------------------------------------------------------
  font = wezterm.font_with_fallback({
    "CaskaydiaCove Nerd Font",
    "Noto Sans JP",
  }),
  font_size = 12.0,

  --------------------------------------------------------------------------------
  -- Window
  --------------------------------------------------------------------------------
  initial_cols = 190,
  initial_rows = 60,
  window_background_opacity = 0.85,
  macos_window_background_blur = 20,
  window_decorations = "RESIZE",
  exit_behavior = "Close",

  --------------------------------------------------------------------------------
  -- Tab Bar
  --------------------------------------------------------------------------------
  enable_tab_bar = true,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_max_width = 32,

  --------------------------------------------------------------------------------
  -- Pane
  --------------------------------------------------------------------------------
  inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.4,
  },

  --------------------------------------------------------------------------------
  -- Scrollbar
  --------------------------------------------------------------------------------
  enable_scroll_bar = false,

  --------------------------------------------------------------------------------
  -- Color Scheme
  --------------------------------------------------------------------------------
  color_scheme = "Gruvbox Dark (Gogh)",

  colors = {
    background = "#141617",
    cursor_bg = "#FC802D",
    selection_bg = "#FC802D",
    split = "#3c3836",
    tab_bar = {
      background = "#141617",
      active_tab = {
        bg_color = "#d65d0e",
        fg_color = "#ebdbb2",
        intensity = "Bold",
      },
      inactive_tab = {
        bg_color = "#141617",
        fg_color = "#928374",
      },
      inactive_tab_hover = {
        bg_color = "#3c3836",
        fg_color = "#ebdbb2",
      },
      new_tab = {
        bg_color = "#141617",
        fg_color = "#928374",
      },
      new_tab_hover = {
        bg_color = "#3c3836",
        fg_color = "#ebdbb2",
      },
    },
  },
}
