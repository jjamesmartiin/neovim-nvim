-- ── GitHub Copilot ──────────────────────────────────────────────────────────

-- Dynamic workspace folders: defaults to current working directory (no hardcoded paths)
vim.g.copilot_workspace_folders = { vim.fn.getcwd() }

-- Set Copilot workspace to current file directory
vim.keymap.set("n", "<Leader>D", function()
  local dir = vim.fn.expand("%:p:h")
  vim.g.copilot_workspace_folders = { dir }
  print("Copilot workspace set to: " .. dir)
end, { desc = "Set Copilot workspace to current file directory" })

vim.g.copilot_filetypes = { ["*"] = true }
vim.g.copilot_no_tab_map = true
vim.g.copilot_enabled = 0

-- Autocomplete accept via Ctrl + l in insert mode
vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true, script = true })

-- Enable / disable shortcuts
vim.keymap.set("n", "<Leader>cpo", "<CMD>Copilot enable<CR>", { desc = "Enable Copilot" })
vim.keymap.set("n", "<Leader>cpO", "<CMD>Copilot disable<CR>", { desc = "Disable Copilot" })
vim.keymap.set("n", "<Leader>cpe", "<CMD>Copilot enable<CR>", { desc = "Enable Copilot" })
vim.keymap.set("n", "<Leader>cpd", "<CMD>Copilot disable<CR>", { desc = "Disable Copilot" })
