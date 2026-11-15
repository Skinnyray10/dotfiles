-- WezTerm config shared between Omarchy (Linux) and macOS.
-- Theme: Cyberpunk: Edgerunners (neon yellow, cyan and hot pink on night-city black).
-- Docs: https://wezterm.org/config/files.html
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Detect the OS so one file can serve both machines.
local is_mac = wezterm.target_triple:find("darwin") ~= nil

-- Palette ---------------------------------------------------------------
local p = {
  bg = "#0b0614", -- night-city black with a purple tint
  bg_alt = "#1a1026", -- raised surfaces (inactive tabs, selection)
  fg = "#d9f6ff", -- cold white
  yellow = "#fcee0a", -- David's jacket / Cyberpunk yellow
  cyan = "#00f0ff", -- Lucy's neon
  pink = "#ff2a6d", -- hot pink / magenta glow
  purple = "#b026ff",
  mint = "#05ffa1",
  blue = "#00b7ff",
  dim = "#6b5b8a", -- muted text
}

-- Font ------------------------------------------------------------------
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = is_mac and 13 or 10

-- Colors ----------------------------------------------------------------
config.colors = {
  foreground = p.fg,
  background = p.bg,
  cursor_bg = p.yellow,
  cursor_fg = p.bg,
  cursor_border = p.yellow,
  selection_bg = p.pink,
  selection_fg = p.bg,
  split = p.purple,
  visual_bell = p.pink,
  ansi = { p.bg_alt, p.pink, p.mint, p.yellow, p.blue, p.purple, p.cyan, p.fg },
  brights = { p.dim, "#ff5c8f", "#5cffc0", "#fff566", "#4dcfff", "#d17aff", "#7af7ff", "#ffffff" },
  tab_bar = {
    background = p.bg,
    new_tab = { bg_color = p.bg, fg_color = p.cyan },
    new_tab_hover = { bg_color = p.cyan, fg_color = p.bg },
  },
}

-- Window ----------------------------------------------------------------
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20 -- ignored on Linux (Hyprland does its own blur)
config.window_padding = { left = 12, right = 12, top = 10, bottom = 10 }
-- Hyprland draws its own borders, macOS keeps a resizable frame.
config.window_decorations = is_mac and "RESIZE" or "NONE"
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.6 }

-- Cursor and bell -------------------------------------------------------
config.default_cursor_style = "SteadyBlock"
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 150,
  target = "BackgroundColor",
}

-- Tab bar: slim, at the bottom, powerline style ------------------------
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 28

local sep = wezterm.nerdfonts.pl_left_hard_divider

wezterm.on("format-tab-title", function(tab)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  local bg = tab.is_active and p.yellow or p.bg_alt
  local fg = tab.is_active and p.bg or p.dim
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
    { Text = " " .. (tab.tab_index + 1) .. " " .. title .. " " },
    { Background = { Color = p.bg } },
    { Foreground = { Color = bg } },
    { Text = sep },
  }
end)

-- Right side of the tab bar: workspace and clock ----------------------
wezterm.on("update-right-status", function(window)
  local time = wezterm.strftime("%H:%M")
  window:set_right_status(wezterm.format({
    { Foreground = { Color = p.pink } },
    { Text = " " .. window:active_workspace() .. " " },
    { Foreground = { Color = p.cyan } },
    { Text = " " .. time .. " " },
  }))
end)

return config
