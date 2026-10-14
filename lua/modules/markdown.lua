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

-- ── Restored from the pre-refactor config (c370a06c^) ────────────────────────

-- Limelight: dim everything but the current paragraph
vim.g.limelight_conceal_ctermfg = 240

vim.cmd([[
  function! ToggleLimelight()
    if exists("g:limelight_active") && g:limelight_active
      Limelight!
      let g:limelight_active = 0
    else
      Limelight
      let g:limelight_active = 1
    endif
  endfunction
  nnoremap <Leader>L :call ToggleLimelight()<CR>

  " Convert the buffer with pandoc, output into a new scratch tab
  function! ConvertWithPandoc()
    let l:fileext = expand('%:e')
    let l:filetype = &filetype

    let l:from_fmt = ""
    let l:to_fmt = ""

    if l:fileext ==# 'md' || l:filetype ==# 'markdown'
      let l:from_fmt = 'markdown'
      let l:to_fmt = 'mediawiki'
    elseif l:fileext ==# 'wiki' || l:filetype ==# 'mediawiki'
      let l:from_fmt = 'mediawiki'
      let l:to_fmt = 'markdown'
    else
      let l:from_fmt = 'mediawiki'
      let l:to_fmt = 'markdown'
    endif

    let l:content = join(getline(1, '$'), "\n")
    let l:command = 'pandoc -f ' . l:from_fmt . ' -t ' . l:to_fmt
    let l:output = system(l:command, l:content)

    if v:shell_error != 0
      echo "Pandoc conversion failed!"
      return
    endif

    execute 'tabnew'
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile

    if l:to_fmt ==# 'markdown'
      setlocal filetype=markdown
    elseif l:to_fmt ==# 'mediawiki'
      setlocal filetype=mediawiki
    endif

    call setline(1, split(l:output, "\n"))
    echo "Converted content (" . l:from_fmt . " -> " . l:to_fmt . ") loaded in a new tab"
  endfunction
  command! PandocConvert call ConvertWithPandoc()
  nnoremap <Leader>M :call ConvertWithPandoc()<CR>

  " Tick / untick todo boxes, on the current line or a range
  nnoremap <Leader>B /\[ \]<CR>
  nnoremap <Leader>X :silent! execute "/- \\[ \\]"<CR>
  function! ToggleTodoBox(...) range
    for lnum in range(a:firstline, a:lastline)
      let line = getline(lnum)
      if line =~ '- \[ \]'
        let updated = substitute(line, '- \[ \]', '- [x]', '')
      elseif line =~ '- \[x\]'
        let updated = substitute(line, '- \[x\]', '- [ ]', '')
      else
        let updated = line
      endif
      call setline(lnum, updated)
    endfor
  endfunction
  nnoremap <silent> <leader>x :call ToggleTodoBox()<CR>
  vnoremap <silent> <leader>x :call ToggleTodoBox()<CR>
]])
