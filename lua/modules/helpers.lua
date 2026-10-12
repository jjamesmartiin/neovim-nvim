-- ── Custom Helper Tools (Fuzzy find, Refactor, List continuation) ───────────

-- Recent files & line-number-sorted buffer fuzzy search
local cbff_ok, cbff = pcall(require, "current_buffer_fuzzy_find")
if cbff_ok then
  vim.keymap.set("n", "<Leader>h", cbff.recent_files, { desc = "Recent files finder" })
  vim.keymap.set("n", "<Leader>C", cbff.current_buffer_fuzzy_find, { desc = "Current buffer fuzzy find (line sorted)" })
end

-- Cross-project file rename and reference update
local rename_ok, rename = pcall(require, "rename_file_and_text")
if rename_ok then
  vim.keymap.set("n", "<Leader>rf", rename.rename_and_refactor, { desc = "Rename file and update references" })
end

-- Smart Markdown list continuation on Enter
local lc_ok, lc = pcall(require, "list_continuation")
if lc_ok then
  vim.keymap.set("i", "<CR>", lc.handle_enter, { expr = true, silent = true, desc = "Smart list continuation" })
end
