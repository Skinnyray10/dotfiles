-- Clipboard sync over tmux/SSH/herdr relies on /proc and Wayland, so it is
-- Linux-only. Neovim's built-in OSC 52 support covers SSH on other systems.
if vim.fn.has("linux") == 1 then
  require("config.remote_clipboard").setup()
end
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
