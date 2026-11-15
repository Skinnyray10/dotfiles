-- WezTerm config shared between Omarchy (Linux) and macOS.
-- Docs: https://wezterm.org/config/files.html
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Detect the OS so one file can serve both machines.
local is_mac = wezterm.target_triple:find("darwin") ~= nil

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = is_mac and 13 or 10

-- Look
config.color_scheme = "Kanagawa (Gogh)"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.95
-- Hyprland draws its own borders, macOS keeps a resizable frame.
config.window_decorations = is_mac and "RESIZE" or "NONE"

return config
