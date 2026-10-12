-- ── Telescope Fuzzy Finder ──────────────────────────────────────────────────

local ok, telescope = pcall(require, "telescope")
if not ok then return end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local custom_actions = {}
custom_actions.insert_path = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local current_line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1], cursor_pos[2]
  local new_line = current_line:sub(1, col) .. selection.value .. current_line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, col + #selection.value })
end

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-i>"] = custom_actions.insert_path,
      },
    },
  },
})

-- Keymaps
vim.keymap.set("n", "<Leader>p", "<CMD>Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<Leader>f", "<CMD>Telescope live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<Leader>F", "<CMD>Telescope live_grep hidden=true no_ignore=true<CR>", { desc = "Live Grep (Hidden)" })
vim.keymap.set("n", "<Leader>o", "<CMD>Telescope oldfiles<CR>", { desc = "Recent Files" })
vim.keymap.set({ "n", "i" }, "<M-i>", "<Esc><CMD>Telescope find_files hidden=true<CR>", { desc = "Find Files (Hidden)" })
vim.keymap.set({ "n", "i" }, "<M-I>", "<Esc><CMD>Telescope find_files hidden=true<CR>", { desc = "Find Files (Hidden)" })
