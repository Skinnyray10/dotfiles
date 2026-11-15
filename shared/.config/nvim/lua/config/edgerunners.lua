-- Cyberpunk: Edgerunners colors, applied on top of tokyonight.
-- The palette is shared with WezTerm, Starship, lazygit and the Omarchy theme
-- (see "Theme palette" in the README). Keep the hex values in sync.
local p = {
  bg = "#0b0614", -- night-city black with a purple tint
  bg_dark = "#080410",
  bg_alt = "#1a1026", -- raised surfaces
  bg_select = "#2a1840",
  fg = "#d9f6ff", -- cold white
  fg_dark = "#b8d8e6",
  dim = "#6b5b8a", -- comments, muted text
  yellow = "#fcee0a",
  cyan = "#00f0ff",
  pink = "#ff2a6d",
  purple = "#b026ff",
  mint = "#05ffa1",
  blue = "#00b7ff",
  orange = "#ff8a3d",
}

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      on_colors = function(c)
        c.bg = p.bg
        c.bg_dark = p.bg_dark
        c.bg_float = p.bg_dark
        c.bg_sidebar = p.bg_dark
        c.bg_statusline = p.bg_dark
        c.bg_highlight = p.bg_alt
        c.bg_visual = p.bg_select
        c.fg = p.fg
        c.fg_dark = p.fg_dark
        c.fg_gutter = p.dim
        c.comment = p.dim
        c.border = p.purple
        c.red = p.pink
        c.yellow = p.yellow
        c.green = p.mint
        c.cyan = p.cyan
        c.blue = p.blue
        c.magenta = p.purple
        c.purple = p.purple
        c.orange = p.orange
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },
}
