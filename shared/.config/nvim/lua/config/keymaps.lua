-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Notes (~/notes), all under <leader>z
local notes = vim.fn.expand("~/notes")

local function read_template(name)
  local f = io.open(notes .. "/templates/" .. name .. ".md", "r")
  if not f then
    return {}
  end
  local content = f:read("*a")
  f:close()
  return vim.split(content, "\n", { plain = true })
end

-- Open path; if it doesn't exist yet, fill it from a template
local function open_from_template(path, template, title)
  local is_new = vim.fn.filereadable(path) == 0
  vim.cmd.edit(vim.fn.fnameescape(path))
  if is_new then
    local lines = read_template(template)
    for i, line in ipairs(lines) do
      lines[i] = line:gsub("{{date}}", os.date("%Y-%m-%d"))
    end
    if title and lines[1] then
      lines[1] = "# " .. title
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
end

local function new_note(dir, template)
  vim.ui.input({ prompt = "Title: " }, function(title)
    if not title or title == "" then
      return
    end
    local slug = title:lower():gsub("[^%w]+", "-"):gsub("^-+", ""):gsub("-+$", "")
    open_from_template(("%s/%s/%s.md"):format(notes, dir, slug), template, title)
  end)
end

vim.keymap.set("n", "<leader>zd", function()
  open_from_template(notes .. "/daily/" .. os.date("%Y-%m-%d") .. ".md", "daily")
end, { desc = "Today's daily note" })

vim.keymap.set("n", "<leader>zi", function()
  vim.cmd.edit(notes .. "/inbox.md")
end, { desc = "Inbox" })

vim.keymap.set("n", "<leader>zc", function()
  new_note("concepts", "concept")
end, { desc = "New concept" })

vim.keymap.set("n", "<leader>zp", function()
  new_note("projects", "project")
end, { desc = "New project" })

vim.keymap.set("n", "<leader>zf", function()
  Snacks.picker.files({ cwd = notes })
end, { desc = "Find note" })

vim.keymap.set("n", "<leader>zg", function()
  Snacks.picker.grep({ cwd = notes })
end, { desc = "Grep notes" })
