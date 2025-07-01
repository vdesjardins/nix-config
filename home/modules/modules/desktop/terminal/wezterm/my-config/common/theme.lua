local wezterm = require("wezterm")

local M = {}

function M.configure(config, globals)
  config.font = wezterm.font({
    family = globals.font,
    weight = "Medium",
    harfbuzz_features = {
      "ss01",
      "ss02",
      "ss03",
      "ss04",
      "ss05",
      "ss06",
      "ss07",
      "ss08",
      "calt",
      "dlig",
    },
  })

  config.font_rules = {
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font({ family = globals.font_italic, weight = "Bold", style = "Italic" }),
    },
    {
      italic = true,
      intensity = "Half",
      font = wezterm.font({ family = globals.font_italic, weight = "DemiBold", style = "Italic" }),
    },
    {
      italic = true,
      intensity = "Normal",
      font = wezterm.font({ family = globals.font_italic, style = "Italic" }),
    },
  }

  config.color_scheme = globals.color_scheme

  config.bold_brightens_ansi_colors = true

  config.tab_bar_at_bottom = true

  config.inactive_pane_hsb = { hue = 1.0, saturation = 0.9, brightness = 1.0 }
end

return M
