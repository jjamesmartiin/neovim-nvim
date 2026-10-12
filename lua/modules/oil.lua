-- ── Oil.nvim File Manager ───────────────────────────────────────────────────

local ok, oil = pcall(require, "oil")
if not ok then return end

oil.setup({
  default_file_explorer = true,
  columns = { "icon" },
  cleanup_delay_ms = 1000,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    -- Unmap C-h and C-l to keep tmux-navigator working seamlessly
    ["<C-h>"] = false,
    ["<C-l>"] = false,
  },
})

-- Open Oil in float mode
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory with Oil" })
