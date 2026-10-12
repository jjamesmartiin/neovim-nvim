-- ── Treesitter & Sticky Context ─────────────────────────────────────────────

local ok, treesitter_context = pcall(require, "treesitter-context")
if ok then
  treesitter_context.setup({
    max_lines = 3,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = "outer",
  })

  -- Minimal Gruvbox styling for Sticky Scroll
  vim.api.nvim_set_hl(0, "TreesitterContext", { link = "NormalFloat" })
  vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "LineNr" })
  vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
end
