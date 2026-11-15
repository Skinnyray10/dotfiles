-- Colorscheme spec, shared between Omarchy (Linux) and macOS.
--
-- On Omarchy, `omarchy theme set` keeps this file current by switching the
-- `current/theme` link, so we load that file when it exists. The module name
-- must stay `plugins.theme` because omarchy-theme-hotreload.lua reloads it.
-- On macOS (or any machine without Omarchy) we fall back to a plain theme.
local omarchy_theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

if vim.uv.fs_stat(omarchy_theme) then
  return dofile(omarchy_theme)
end

return {
  { "folke/tokyonight.nvim", priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },
}
