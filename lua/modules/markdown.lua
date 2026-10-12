-- ── Markdown Preview, Images & Links ─────────────────────────────────────────

-- markdown-preview-nvim configuration
vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_port = os.getenv("MARKDOWN_PORT") or "3010"
vim.g.mkdp_open_ip = os.getenv("MARKDOWN_IP") or ""
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_browser = "google-chrome-stable"

vim.keymap.set("n", "<Leader>m", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

-- Table mode & EasyAlign
vim.g.table_mode_corner = "|"

-- Download image from URL
local function download_image()
  local url = vim.fn.input("Enter image URL: ")
  if url == "" then return end
  local filename = vim.fn.input("Enter file name (default: image.png): ")
  if filename == "" then filename = "image.png" end
  local dir = vim.fn.expand("%:p:h") .. "/images/"
  vim.fn.mkdir(dir, "p")
  local full_path = dir .. filename
  local cmd = string.format("curl -s -L -o %s %s", vim.fn.shellescape(full_path), vim.fn.shellescape(url))
  local result = os.execute(cmd)
  if result == 0 then
    local rel_path = "images/" .. filename
    local markdown_link = string.format("![%s](%s)", filename, rel_path)
    vim.api.nvim_put({ markdown_link }, "l", true, true)
    print("Image saved to " .. rel_path)
  else
    print("Failed to download image.")
  end
end

-- Paste image from clipboard
local function paste_image()
  local filename = vim.fn.input("Enter image name (e.g., screenshot.png): ")
  if filename == "" then
    local date = os.date("%y-%m-%d-%H-%M-%S")
    filename = date .. ".png"
  end
  local dir = vim.fn.expand("%:p:h") .. "/images/"
  vim.fn.mkdir(dir, "p")
  local full_path = dir .. filename
  local cmd
  if vim.fn.has("unix") == 1 and os.getenv("WAYLAND_DISPLAY") then
    cmd = string.format("wl-paste -t image/png > %s", vim.fn.shellescape(full_path))
  else
    cmd = string.format("xclip -selection clipboard -t image/png -o > %s", vim.fn.shellescape(full_path))
  end
  local result = os.execute(cmd)
  if result == 0 then
    local rel_path = "images/" .. filename
    local markdown_link = string.format("![](%s)", rel_path)
    vim.api.nvim_put({ markdown_link }, "l", true, true)
    print("Image pasted: " .. rel_path)
  else
    print("Failed to paste image from clipboard.")
  end
end

vim.api.nvim_create_user_command("DownloadImage", download_image, {})
vim.api.nvim_create_user_command("PasteImage", paste_image, {})
vim.keymap.set("n", "<Leader>V", paste_image, { desc = "Paste image from clipboard" })

-- Custom gf handler for markdown links: [text](path)
vim.api.nvim_create_augroup("MarkdownGf", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownGf",
  pattern = { "markdown", "markdown.pandoc" },
  callback = function()
    vim.keymap.set("n", "gf", function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2] + 1
      for link in line:gmatch("%b[]%((%S-)%)") do
        local start_idx, end_idx = line:find("%b[]%(" .. vim.pesc(link) .. "%)")
        if start_idx and col >= start_idx and col <= end_idx then
          local current_dir = vim.fn.expand("%:p:h")
          local target_path = vim.fn.resolve(current_dir .. "/" .. link)
          if vim.fn.filereadable(target_path) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(target_path))
            return
          end
        end
      end
      vim.cmd("normal! gf")
    end, { buffer = true, silent = true, desc = "Follow markdown link" })
  end,
})
