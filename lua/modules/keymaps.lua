-- ── Core Keymaps & Shortcuts ────────────────────────────────────────────────

vim.g.mapleader = " "

vim.cmd [[
  " Navigation: jump blocks with J and K
  nnoremap J }
  nnoremap K {
  vnoremap J }
  vnoremap K {

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
  " (normal-mode <Leader>x is ToggleTodoBox -- see modules/markdown.lua)
  " (visual-mode <Leader>x is ToggleTodoBox -- see modules/markdown.lua; use "+d to cut)

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
  nnoremap <Leader>t :tabnew<CR>
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

  " ── Restored from the pre-refactor config (c370a06c^) ──
  " Write all
  nnoremap <Leader>s :wa<CR>
  nnoremap <Leader>wa :wa<CR>

  " Toggle wrap
  nnoremap <Leader>z :set wrap!<CR>

  " Tab & buffer keys, old set kept alongside the newer ones
  nnoremap <Leader>j :tabprevious<CR>
  nnoremap <Leader>k :tabnext<CR>
  nnoremap <Leader>J :bprev<CR>
  nnoremap <Leader>K :bnext<CR>
  nnoremap <Leader><Enter> :nohlsearch<CR>

  " Line number variants
  nnoremap <Leader>l :set number relativenumber<CR>
  nnoremap <Leader>lof :set nonumber norelativenumber<CR>
  nnoremap <Leader>lon :set number relativenumber<CR>
  nnoremap <Leader>lno :set nonumber norelativenumber<CR>
  nnoremap <Leader>lnO :set number relativenumber<CR>
  nnoremap <Leader>ll :set nonumber norelativenumber<CR>

  " Toggle listchars
  nnoremap <Leader>N :call ToggleListchars()<CR>
  function! ToggleListchars()
    if &list
      set listchars= nolist
    else
      set list listchars=tab:>␣,trail:~,extends:>,precedes:<,space:·
    endif
  endfunction

  " Mouse clicks stay off
  noremap <LeftMouse> <Nop>
  inoremap <LeftMouse> <Nop>

  " Window navigation, tmux aware
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
  nnoremap <M-Left> <C-w>h
  nnoremap <M-Down> <C-w>j
  nnoremap <M-Up> <C-w>k
  nnoremap <M-Right> <C-w>l
  noremap <silent> <C-h> :<C-U>TmuxNavigateLeft<cr>
  noremap <silent> <C-j> :<C-U>TmuxNavigateDown<cr>
  noremap <silent> <C-k> :<C-U>TmuxNavigateUp<cr>
  noremap <silent> <C-l> :<C-U>TmuxNavigateRight<cr>
  noremap <silent> <C-/> :<C-U>TmuxNavigatePrevious<cr>
  noremap <silent> <M-Left> :<C-U>TmuxNavigateLeft<cr>
  noremap <silent> <M-Down> :<C-U>TmuxNavigateDown<cr>
  noremap <silent> <M-Up> :<C-U>TmuxNavigateUp<cr>
  noremap <silent> <M-Right> :<C-U>TmuxNavigateRight<cr>

  " Terminal in the current file's directory
  nnoremap <C-\> :ToggleTerm dir=%:p:h<CR>i
  inoremap <C-\> <Esc>:ToggleTerm dir=%:p:h<CR>i
  tnoremap <C-\> <C-\><C-n>:ToggleTerm dir=%:p:h<CR>i

  " Window swap
  let g:windowswap_map_keys = 0
  nnoremap <silent> <leader>WW :call WindowSwap#EasyWindowSwap()<CR>

  " Markdown heading levels
  inoremap <F1> #<Space>
  inoremap <F2> ##<Space>
  inoremap <F3> ###<Space>
  inoremap <F4> ####<Space>
  inoremap <F5> #####<Space>
  inoremap <F6> ######<Space>
  inoremap <F7> #######<Space>
  inoremap <F8> ########<Space>
  inoremap <F9> #########<Space>
  inoremap <F10> ##########<Space>
  inoremap <F11> ###########<Space>
  inoremap <F12> ############<Space>

  " Cut to register x in visual mode
  vnoremap x "xd
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

-- Markdown todo item, in insert and normal mode
vim.keymap.set("i", "<C-t>", "- [ ] ", { desc = "Insert markdown todo item" })
vim.keymap.set("n", "<C-t>", "i<C-t>", { remap = true, desc = "Insert markdown todo item" })
