-- ── Git Integration (Lazygit, Blame, Linker, Conflicts) ─────────────────────

-- Lazygit floating terminal
vim.keymap.set("n", "<Leader>g", "<CMD>LazyGit<CR>", { desc = "Open LazyGit" })

-- Git blame toggle (disabled by default)
vim.g.gitblame_enabled = 0
vim.keymap.set("n", "<Leader>b", "<CMD>GitBlameToggle<CR>", { desc = "Toggle Git Blame" })

-- GitLinker (generate permalinks to current lines)
local ok, gitlinker = pcall(require, "gitlinker")
if ok then
  gitlinker.setup({
    opts = {
      action = require("gitlinker.actions").copy_to_clipboard,
    },
    callbacks = {
      ["github.com"] = require("gitlinker.hosts").get_github_type_url,
      ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
    },
    mappings = "<Leader>gy",
  })
  vim.keymap.set({ "n", "v" }, "<Leader>gb", function()
    gitlinker.get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
  end, { desc = "Open Git permalink in browser" })
end
