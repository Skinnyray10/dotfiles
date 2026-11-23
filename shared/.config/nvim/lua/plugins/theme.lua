-- Colorscheme spec, shared between Omarchy (Linux) and macOS.
--
-- On Omarchy, `omarchy theme set` keeps this file current by switching the
-- `current/theme` link, so we load that file when it exists. The module name
-- must stay `plugins.theme` because omarchy-theme-hotreload.lua reloads it.
-- Otherwise (macOS, or the Edgerunners theme) we use config/monokai-edgerunners.lua.
local omarchy_theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
local omarchy_name = vim.fn.expand("~/.local/state/omarchy/current/theme.name")

-- Edgerunners (and any machine without Omarchy) gets our own Monokai Pro
-- Spectrum on the Edgerunners palette. Any other Omarchy theme is followed.
local function omarchy_theme_is_custom()
  local f = io.open(omarchy_name, "r")
  if not f then
    return false
  end
  local name = f:read("*l") or ""
  f:close()
  return name:lower() ~= "edgerunners"
end

if vim.uv.fs_stat(omarchy_theme) and omarchy_theme_is_custom() then
  return dofile(omarchy_theme)
end

return require("config.monokai-edgerunners")
