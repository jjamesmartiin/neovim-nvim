-- ── Terminal Integration (Toggleterm) ───────────────────────────────────────

local ok, toggleterm = pcall(require, "toggleterm")
if ok then
  toggleterm.setup({
    open_mapping = [[<C-\>]],
    direction = "float",
    float_opts = {
      border = "curved",
    },
  })
end

-- Easy terminal exit mapping
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
