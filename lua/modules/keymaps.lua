-- ── Core Keymaps & Shortcuts ────────────────────────────────────────────────

vim.g.mapleader = " "

vim.cmd [[
  " Navigation: jump blocks with J and K
  nnoremap J }
  nnoremap K {

  " Clipboard: explicitly use system clipboard (+ register)
  " Cursor stays at the end of selection after copying
  vnoremap c "+ygv<Esc>
  vnoremap <Leader>c "+ygv<Esc>
  nnoremap <Leader>c "+y
  vnoremap y ygv<Esc>

  " Pasting from system clipboard
  nnoremap <Leader>v "+p
  inoremap <C-v> <C-r>+

  " Cutting: explicitly use system clipboard
  vnoremap <Leader>x "+d
  nnoremap <Leader>x "+d

  " Saving and closing
  nnoremap <Leader>w :w<CR>
  nnoremap <Leader>q :q<CR>
  nnoremap <Leader>wq :wq<CR>
  nnoremap <Leader>Q :q!<CR>

  " Quick reload current file
  nnoremap <Leader>r :e <Bar> echo "reloaded file"<CR>

  " Open file manager at current directory
  nnoremap <silent> <Leader>e :silent !nautilus "%:p:h" &<CR>

  " Tab & buffer navigation
  nnoremap <Leader>, :tabprevious<CR>
  nnoremap <Leader>. :tabnext<CR>
  nnoremap <C-t> :tabnew<CR>
  nnoremap <Leader>[ :bprev<CR>
  nnoremap <Leader>] :bnext<CR>
  nnoremap <Leader>bd :bd<CR>

  " Clear search highlight
  nnoremap <Leader>/ :nohlsearch<CR>

  " Toggle numbers
  nnoremap <Leader>n :set number! relativenumber!<CR>

  " Toggle listchars
  nnoremap <Leader>i :set list!<CR>

  " Reload configuration
  nnoremap <Leader>R :source ~/.config/nvim/init.lua<CR>

  " Set working directory to current file directory
  nnoremap <Leader>U :lcd %:p:h<CR>
]]

-- Smooth scrolling: approximately 1/3 of the page
local function scroll_third_down()
  local lines = math.floor(vim.api.nvim_win_get_height(0) / 3)
  vim.cmd("normal! " .. lines .. "jzz")
end

local function scroll_third_up()
  local lines = math.floor(vim.api.nvim_win_get_height(0) / 3)
  vim.cmd("normal! " .. lines .. "kzz")
end

vim.keymap.set("n", "<C-d>", scroll_third_down, { desc = "Scroll 1/3 page down" })
vim.keymap.set("n", "<C-u>", scroll_third_up, { desc = "Scroll 1/3 page up" })

-- Timestamps & Journal date insertion (Insert mode)
vim.keymap.set("i", "<C-d>", '<C-R>=strftime("%y%m%d")<CR>', { expr = true })
vim.keymap.set("i", "<C-d><C-d>", '<C-R>=strftime("%y%m%d")<CR>', { expr = true })
vim.keymap.set("i", "<C-d><C-t>", '<C-R>=strftime("%y%m%d@%H%M")<CR>', { expr = true })
vim.keymap.set("i", "<C-w>", '<C-R>=strftime("# Week %V")<CR>', { expr = true })
vim.keymap.set("i", "<C-d><C-w>", '<C-R>=strftime("## %y%m%d %A")<CR>', { expr = true })
vim.keymap.set("i", "<C-d><C-e>", '<C-R>=strftime("### %y%m%d@%H%M")<CR>', { expr = true })

-- Flash.nvim navigation
local flash_ok, flash = pcall(require, "flash")
if flash_ok then
  vim.keymap.set({ "n", "v" }, "s", function() flash.jump({ modes = { char = { enabled = false } } }) end, { desc = "Flash Jump" })
  vim.keymap.set({ "n", "v" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
  vim.keymap.set("i", "<C-s>", function() flash.jump({ modes = { char = { enabled = false } } }) end, { desc = "Flash Jump (Insert)" })
end
