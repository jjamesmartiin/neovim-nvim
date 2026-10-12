-- ── Optional Journal Encryption (ccryptor.nvim) ─────────────────────────────

local journal_dir = vim.fn.expand(os.getenv("JOURNAL_DIR") or "~/notes/journal/")

local ok, ccryptor = pcall(require, "ccryptor")
if ok then
  ccryptor.setup({
    dir_path = journal_dir,
  })
end
