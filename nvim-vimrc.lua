-- tree sitter
require("treesitter-context").setup({
  max_lines = 3,           -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',    -- Which context lines to discard if max_lines is exceeded
})
-- Minimal Gruvbox styling for Sticky Scroll
vim.api.nvim_set_hl(0, "TreesitterContext", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "LineNr" })
vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })


--
--
-- codeium windsurf
-- require("codeium").setup({})
-- current user func

local function get_current_user()
    local user = os.getenv("USER") or os.getenv("USERNAME")
    return user or "Unknown"
end

local current_user = get_current_user()


--------------------------------------------------------------------------------

-- oil setup
require("oil").setup({
	cleanup_delay_ms = 1000,
	view_options = {
	  show_hidden = true
	}
})
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

--------------------------------------------------------------------------------

-- glow setup: https://github.com/ellisonleao/glow.nvim?tab=readme-ov-file#setup
--require('glow').setup({
--  width = 80,
--  height = 100,
--  width_ratio = 1, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
--  height_ratio = 1,
--})

--------------------------------------------------------------------------------

-- TELESCOPE FUNCTIONS
-- part of the config
-- Set your fixed file path here
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
-- Set your fixed file path here
local fixed_path = "~/gitprojects/personal/"
function recent_files()
  require('telescope.builtin').find_files({
    prompt_title = "Recent Files",
    cwd = fixed_path,
    find_command = { "sh", "-c", "find " .. fixed_path .. " -type f -not -path '*/\\.git/*' -printf '%T@ %p\n' | sort -n -r | cut -d' ' -f2-" },
  })
end

local custom_actions = {}
custom_actions.insert_path = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  vim.api.nvim_put({ entry.value }, '', false, true)
end

custom_actions.insert_markdown_link = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local path = entry.value
  local markdown_link = string.format("[%s](%s)", path, path)
  vim.api.nvim_put({ markdown_link }, '', false, true)
end

-- telescope config
require('telescope').setup({
  defaults = {
    scroll_strategy = 'limit',
    layout_strategy = 'vertical',
    layout_config = {
      mirror = true,
      prompt_position = 'bottom',
      preview_height = 0.65,
      width = 0.75,
      height = 0.95,
    },
    mappings = {
      i = {
        -- Map Ctrl-i to insert_path in insert mode
        ["<M-i>"] = custom_actions.insert_path,
        -- Map M-I to insert_markdown_link in insert mode
        ["<M-I>"] = custom_actions.insert_markdown_link,
        -- Map Ctrl-v to paste from system clipboard
        ["<C-v>"] = { "<C-r>+", type = "command" }
      },
      n = {
        -- Map i to insert_path in normal mode
        ["<M-i>"] = custom_actions.insert_path,
        -- Map M-I to insert_markdown_link in normal mode
        ["<M-I>"] = custom_actions.insert_markdown_link
      },
    },  
  }
})
require('telescope').load_extension('fzf')

------------------------------------------------------------------------------
-- fzf-vim config
-- local actions = require "fzf-lua.actions"
-- require'fzf-lua'.setup {
--   winopts = {
--     height = 0.95,
--     preview = {
--       layout = 'vertical',
--     },
--   },
-- }

------------------------------------------------------------------------------

-- leap 
-- require('leap').create_default_mappings()


-- add flash configuration
-- TODO: add a setting fix so that flash doesn't override F and f 
require("flash").setup({ modes = { char = { enabled = false }}})
vim.keymap.set("v", "s", function() require("flash").jump({ modes = { char = { enabled = false }}}) end, { desc = "Flash Jump (Normal)" })
vim.keymap.set("n", "s", function() require("flash").jump({ modes = { char = { enabled = false }}}) end, { desc = "Flash Jump (Normal)" })
vim.keymap.set("n", "S", function() require("flash").jump({ modes = { char = { enabled = false }}}) end, { desc = "Flash Jump (Normal)" })
vim.keymap.set("v", "S", function() require("flash").jump({ modes = { char = { enabled = false }}}) end, { desc = "Flash Jump (Normal)" })
-- vim.keymap.set("n", "S", function() require("flash").jump({ modes = { char = { enabled = false }}}) end, { desc = "Flash Jump (Normal)" })
vim.keymap.set("i", "<C-s>", function() require("flash").jump({ modes = { char = { enabled = false }}}) end, { desc = "Flash Jump (Insert)" })
vim.keymap.set("i", "<C-s>", function() require("flash").jump({ modes = { char = { enabled = false }}}) end, { desc = "Flash Jump (Insert)" })

-- function() open_flash() 
--   require("flash").
-- end

------------------------------------------------------------------------------

-- vim keybindings below 
vim.cmd [[
set splitbelow
set splitright

let mapleader = "\<Space>"

colorscheme gruvbox 

" was causing problems if left on with multiple tmux windows, I can manage my own saves
set noswapfile 

" turning mouse off so that I can click in and it won't move my cursor
" 251211 turning on the mouse because shoulder pain
set mouse=a
noremap <LeftMouse> <Nop>
" Insert mode
inoremap <LeftMouse> <Nop>

" clipboard=unnamedplus removed - we'll use explicit register mappings instead
" This prevents x and dd from overwriting the system clipboard
set number relativenumber
set scrolloff=5

set nowrap
nnoremap <Leader>z :set wrap!<CR> 



" toggle side numbers 
nnoremap <Leader>n :call ToggleSidenums()<CR>
function! ToggleSidenums()
  if &relativenumber
    set norelativenumber
  else
    set relativenumber " number " used to use number/nonumber when I was hiding these 
  endif
endfunction

" toggle listchars
nnoremap <Leader>N :call ToggleListchars()<CR>
function! ToggleListchars()
  if &list
    set listchars= nolist
  else
    set list listchars=tab:>␣,trail:~,extends:>,precedes:<,space:·
  endif
endfunction

" rebind J and K to be { and } for jumping whitespace
vnoremap J }
vnoremap K {
nnoremap J }
nnoremap K {

" copy - explicitly use system clipboard (+ register) so x and dd don't overwrite it
vnoremap c "+y
vnoremap <Leader>c "+y
nnoremap <Leader>c "+y
"vnoremap y "*y " removing because it's not letting me use this for copying to register during macros

" pasting from system clipboard
vnoremap <Leader>v "+p
nnoremap <Leader>v "+p

" pasting from system clipboard in insert mode
inoremap <C-v> <C-r>+


" cutting - explicitly use system clipboard for cut operations
vnoremap x "xd
vnoremap <Leader>x "xd


" saving file
nnoremap <Leader>wa :wa<CR> 
nnoremap <Leader>w :w<CR>
nnoremap <Leader>s :wa<CR>
" closing
nnoremap <Leader>q :q<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>Q :q!<CR>




" tabs and buffers
" tab switching using ctrl + tab
nnoremap <Leader>j :tabprevious<CR>
nnoremap <Leader>k :tabnext<CR>
" tab with just hold 
nnoremap <M-<> :tabprevious<CR>
nnoremap <>->> :tabnext<CR>

" vim-windowswap
let g:windowswap_map_keys = 0
nnoremap <silent> <leader>WW :call WindowSwap#EasyWindowSwap()<CR>


" vim markdown renderer
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_toc_autofit = 1
" let g:vim_markdown_follow_anchor = 1
" let g:vim_markdown_no_extensions_in_markdown = 1
" let g:vim_markdown_strikethrough = 1
" let g:vim_markdown_autowrite = 1

nnoremap <Leader>, :tabprevious<CR>
nnoremap <Leader>. :tabnext<CR>

" rebind :bprev and :bnext
nnoremap <Leader>J :bprev<CR>
nnoremap <Leader>K :bnext<CR>
 

" Telescope searching
" clear the highlighting from search
nnoremap <Leader><Enter> :nohlsearch<CR> " telescope
" map <Leader>F to search for the current word under the cursor
nnoremap <Leader>W viw"0y<space>:Telescope grep_string<CR><Esc>
"nnoremap <Leader>F :Telescope grep_string<CR><Esc>
"nnoremap <Leader>F :FzfLua grep_visual<CR>

nnoremap <Leader>f :Telescope live_grep<CR>
nnoremap <Leader>F :Telescope live_grep hidden=true no_ignore=true<CR>
nnoremap <Leader>p :Telescope find_files<CR>
inoremap <M-i> <Esc>:Telescope find_files hidden=true<CR>
noremap  <M-i> <Esc>:Telescope find_files hidden=true<CR>
inoremap <M-I> <Esc>:Telescope find_files hidden=true<CR>
noremap  <M-I> <Esc>:Telescope find_files hidden=true<CR>
nnoremap <Leader>o :Telescope oldfiles<CR><Esc>
nnoremap <Leader>C :Telescope current_buffer_fuzzy_find<CR>


" reload configuration
nnoremap <Leader>R :source ~/.config/nvim/init.lua<CR>
nnoremap <Leader>r :e <Bar> echo "reloaded file"<CR>
nnoremap <Leader>e :e <Bar> echo "reloaded file"<CR>

" Function to scroll approximately 1/3 of the page down
function! ScrollThirdDown()
    let l:height = winheight(0)
    let l:scroll_amount = l:height / 4
    execute "normal! " . l:scroll_amount . "\<C-E>"
endfunction

" Function to scroll approximately 1/3 of the page up
function! ScrollThirdUp()
    let l:height = winheight(0)
    let l:scroll_amount = l:height / 3
    execute "normal! " . l:scroll_amount . "\<C-Y>"
endfunction

" Map <C-D> to scroll down 1/3 of the page
nnoremap <C-D> :call ScrollThirdDown()<CR>

" Map <C-U> to scroll up 1/3 of the page
nnoremap <C-U> :call ScrollThirdUp()<CR>

" lazygit
map <leader>G :LazyGit<CR>

" GitBlame
map <leader>g :GitBlameToggle<CR>jk

" buffer switching like Vimium
"nnoremap <Leader>b :Telescope buffers<CR><Esc>
nnoremap <Leader>T :Telescope buffers<CR>

" toggle term key bind | toggleterm
"nnoremap <Leader>t :ToggleTerm<CR>i
" binding to open terminal in current dir
" Set a mapping for Normal, Insert, and Terminal mode
nnoremap <C-\> :ToggleTerm dir=%:p:h<CR>i
inoremap <C-\> <Esc>:ToggleTerm dir=%:p:h<CR>i
tnoremap <C-\> <C-\><C-n>:ToggleTerm dir=%:p:h<CR>i


" set a keybind to insert todo list items
inoremap <C-t> - [ ]<Space>
" Insert the text in normal mode when pressing Ctrl + t
"nnoremap <C-t> i- [ ] <Esc>a
" remove appending so that we stay in normal mode
" go back 5 to the left so that we are on the first character
nnoremap <C-t> i- [ ] <Esc>5h

set ignorecase
set smartcase
" set incsearch, this should remain off
set noincsearch

tnoremap <Esc> <C-\><C-n>

" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
"when indenting with '>', use 2 spaces width
set shiftwidth=2


" expirimental tmux navigator
let g:tmux_navigator_no_mappings = 1
" let  g:tmux_navigator_no_wrap = 1

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
noremap <silent> <C-h> :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <C-j> :<C-U>TmuxNavigateDown<cr>
noremap <silent> <C-k> :<C-U>TmuxNavigateUp<cr>
noremap <silent> <C-l> :<C-U>TmuxNavigateRight<cr>
noremap <silent> <C-/> :<C-U>TmuxNavigatePrevious<cr>

" mapping with meta 
nnoremap <M-Left> <C-w>h
nnoremap <M-Down> <C-w>j
nnoremap <M-Up> <C-w>k
nnoremap <M-Right> <C-w>l
noremap <silent> <M-Left>  :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <M-Down>  :<C-U>TmuxNavigateDown<cr>
noremap <silent> <M-Up>    :<C-U>TmuxNavigateUp<cr>
noremap <silent> <M-Right> :<C-U>TmuxNavigateRight<cr>


" limelight colorscheme help https://github.com/junegunn/limelight.vim?tab=readme-ov-file#options
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
" Function to toggle Limelight
function! ToggleLimelight()
  if exists("g:limelight_active") && g:limelight_active
    Limelight!
    let g:limelight_active = 0
  else
    Limelight
    let g:limelight_active = 1
  endif
endfunction

" Map <Leader>L to toggle Limelight
nnoremap <Leader>L :call ToggleLimelight()<CR>


" turn off all line numbers
nnoremap <Leader>lof :set nonumber norelativenumber<CR>
nnoremap <Leader>lon :set number relativenumber<CR>
nnoremap <Leader>lno :set nonumber norelativenumber<CR>
nnoremap <Leader>lnO :set number relativenumber<CR>
nnoremap <Leader>ll :set nonumber norelativenumber<CR>
nnoremap <Leader>l :set number relativenumber<CR>



" also for goyo
" let g:goyo_height='80%'
" let g:goyo_width='80%'


" make the home and end work 
"set term=xterm-256color


" bind ctrl + shift + d to insert (date +'%y%m%d - %H:%M %p') 
" nnoremap <C-D> i<C-R>=strftime("%y%m%d")<CR>
" do the same but from insert mode
inoremap <C-d> <C-R>=strftime("%y%m%d")<CR>
inoremap <C-d><C-d> <C-R>=strftime("%y%m%d")<CR>
inoremap <C-d><C-t> <C-R>=strftime("%y%m%d@%H%M")<CR>
inoremap <C-d><C-e> ### <C-R>=strftime("%y%m%d@%H%M")<CR><Space>
"inoremap <C-d><C-w> <C-R>=strftime("%y%m%d %A")<CR>
inoremap <C-d><C-w> <C-R>=strftime("## %y%m%d %A")<CR>


nnoremap <Leader>U :lcd %:p:h<CR>

" pandoc functions
function! ConvertWithPandoc()
  " Get the current file's extension and filetype
  let l:fileext = expand('%:e')
  let l:filetype = &filetype
  
  let l:from_fmt = ""
  let l:to_fmt = ""

  " Determine formats based on extension, filetype, or default to wiki -> md
  if l:fileext ==# 'md' || l:filetype ==# 'markdown'
    let l:from_fmt = 'markdown'
    let l:to_fmt = 'mediawiki'
  elseif l:fileext ==# 'wiki' || l:filetype ==# 'mediawiki'
    let l:from_fmt = 'mediawiki'
    let l:to_fmt = 'markdown'
  else
    " Fallback to wiki -> markdown for unknown file types
    let l:from_fmt = 'mediawiki'
    let l:to_fmt = 'markdown'
  endif

  " Get the content of the current buffer
  let l:content = join(getline(1, '$'), "\n")
  let l:command = 'pandoc -f ' . l:from_fmt . ' -t ' . l:to_fmt
  
  " Run the Pandoc command using stdin
  let l:output = system(l:command, l:content)

  " Check for errors during the Pandoc execution
  if v:shell_error != 0
    echo "Pandoc conversion failed!"
    return
  endif

  " Open a new tab and load the output
  execute 'tabnew'
  setlocal buftype=nofile   " Mark as temporary buffer
  setlocal bufhidden=hide   " Do not unload the buffer when abandoned
  setlocal noswapfile       " Do not create a swap file
  
  " Set appropriate filetype for the new scratch buffer
  if l:to_fmt ==# 'markdown'
    setlocal filetype=markdown
  elseif l:to_fmt ==# 'mediawiki'
    setlocal filetype=mediawiki
  endif

  call setline(1, split(l:output, "\n"))
  echo "Converted content (" . l:from_fmt . " -> " . l:to_fmt . ") loaded in a new tab"
endfunction


" Map the function to a command
command! PandocConvert call ConvertWithPandoc()
" Map <Leader>M to run the ConvertWithPandoc function
nnoremap <Leader>M :call ConvertWithPandoc()<CR>


" map to bind <Leader>B to find "[ ]" in the current buffer
" but not remove it
nnoremap <Leader>B /\[ \]<CR>

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
" Normal mode — works on current line
"nnoremap <silent> <leader>X :call ToggleTodoBox()<CR>
nnoremap <Leader>X :silent! execute "/- \\[ \\]"<CR>

" Make it so that it centers the cursor after jumping.
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" vim easy align
" vim-easy-align
  " nmap ga <Plug>(EasyAlign)
  " nnoremap <leader>\ vip:EasyAlign*<Bar><CR>

" vim table mode
let g:table_mode_corner='|'
" vim-table-mode
  " to turn on vim table mode 
  " first press <leader>tm 
  " then start making a table with | col 1 | col 2 |
  " then on the next line enter "||"
  " that should automatically fix the "| ------ |" spacing


inoremap <F1> # 
inoremap <F2> ## 
inoremap <F3> ### 
inoremap <F4> #### 
inoremap <F5> ##### 
inoremap <F6> ###### 
inoremap <F7> ####### 
inoremap <F8> ######## 
inoremap <F9> ######### 
inoremap <F10> ########## 
inoremap <F11> ########### 
inoremap <F12> ############ 






" ============================================
"  Auto-continue list markers (Markdown-style)
" ============================================
" Capture the insert-mode cursor column BEFORE we leave insert mode
function! g:CRSaveCol()
  let g:_cr_icol = col('.')
  return ''
endfunction

function! s:ContinueList()
  let l:lnum   = line('.')
  let l:icol   = g:_cr_icol
  let l:line   = getline(l:lnum)
  let l:len    = strlen(l:line)
  let l:indent = matchstr(l:line, '^\s*')
  let l:at_end = (l:icol > l:len)

  " ── Cursor NOT at end of line: plain split ─────────────
  if !l:at_end
    let l:before = strpart(l:line, 0, l:icol - 1)
    let l:after  = strpart(l:line, l:icol - 1)
    call setline(l:lnum, l:before)
    call append(l:lnum, l:after)
    call cursor(l:lnum + 1, 1)
    startinsert
    return
  endif

  " ── Cursor at end of line ──────────────────────────────

  " Bare marker with no text — stop the list, clear the line
  if l:line =~# '^\s*[-*]\s*$'
        \ || l:line =~# '^\s*- \[.\]\s*$'
        \ || l:line =~# '^\s*\d\+\.\s*$'
    call setline(l:lnum, '')
    startinsert
    return
  endif

  " Detect marker type and build the next one
  let l:marker = ''
  if l:line =~# '^\s*- \[.\]'
    let l:marker = l:indent . '- [ ] '
  elseif l:line =~# '^\s*\*\s'
    let l:marker = l:indent . '* '
  elseif l:line =~# '^\s*-\s'
    let l:marker = l:indent . '- '
  elseif l:line =~# '^\s*\d\+\.\s'
    let l:num    = str2nr(matchstr(l:line, '^\s*\zs\d\+'))
    let l:marker = l:indent . (l:num + 1) . '. '
  endif

  if l:marker !=# ''
    call append(l:lnum, l:marker)
    call cursor(l:lnum + 1, col([l:lnum + 1, '$']))
    startinsert!
  else
    " No marker — just open a new line
    call append(l:lnum, '')
    call cursor(l:lnum + 1, 1)
    startinsert
  endif
endfunction

inoremap <silent> <CR> <C-R>=g:CRSaveCol()<CR><Esc>:call <SID>ContinueList()<CR>
" ============================================
"  END Auto-continue list markers (Markdown-style)
" ============================================



















" expiremental setting spaces as filename
" https://chatgpt.com/c/68af7287-3014-8320-8ff8-a4a95e507ebc
"set isfname+=32
set isfname+=124

]]

--------------------------------------------------------------------------------

-- Clipboard configuration
-- Check if we're in Wayland
local is_wayland = os.getenv('WAYLAND_DISPLAY') ~= nil

if is_wayland and vim.fn.executable('wl-copy') == 1 then
  -- Wayland: use wl-clipboard
  vim.g.clipboard = {
    name = 'wl-clipboard',
    copy = {
      ['+'] = 'wl-copy --type text/plain',
      ['*'] = 'wl-copy --type text/plain --primary',
    },
    paste = {
      ['+'] = 'wl-paste --no-newline',
      ['*'] = 'wl-paste --no-newline --primary',
    },
    cache_enabled = 1,
  }
else
  -- TTY/SSH: use Neovim's built-in OSC 52 clipboard provider
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

--------------------------------------------------------------------------------

-- these keybinds need to come after the vim bindinds otherwise they don't load until reloading the configuration
vim.api.nvim_set_keymap('n', '<leader>h', ':lua recent_files()<CR>', { noremap = true, silent = true })


require"gitlinker".setup({
  opts ={
    add_current_line_on_normal_mode = false,
    action_callback = require"gitlinker.actions".copy_to_clipboard,
    print_url = true,
  },
  callbacks = {
    ["github.com"] = require"gitlinker.hosts".get_github_type_url,
    ["gitlab.com"] = require"gitlinker.hosts".get_gitlab_type_url,
    -- ["gitlab.company.work"] = require"gitlinker.hosts".get_gitlab_type_url,
    -- [".company.work"] = require"gitlinker.hosts".get_gitlab_type_url,
  },
  mappings = "<leader>gy"
})

--------------------------------------------------------------------------------
local Terminal = require('toggleterm.terminal').Terminal

-- Define the on_close function
local function on_terminal_close(term)
  -- Send the 'exit' command to the terminal
  term:send("exit\n")
end

require("toggleterm").setup({
  -- open_mapping = [[<c-\>]],
  direction = 'float',
  autochdir = false,
  --on_close = on_terminal_close, -- run the on_close function when the terminal closes
  start_in_insert = false,
})


-- disable git blame by default
vim.g.gitblame_enabled = 0


--------------------------------------------------------------------------------

-- Create a Lua function to paste an image from the clipboard
local function paste_image()
  -- Get the current file's directory and create an 'images' folder
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    print("No file is currently open")
    vim.api.nvim_command("redraw") -- Refresh the screen
    return
  end

  local file_dir = vim.fn.fnamemodify(current_file, ":h")
  local images_dir = file_dir .. "/images"

  -- Create the 'images' directory
  vim.fn.mkdir(images_dir, "p")

  -- Generate a timestamped filename for the image
  local timestamp = os.date("%Y%m%d%H%M%S")
  
  -- Check session type and available tools
  local is_wayland = os.getenv('WAYLAND_DISPLAY') ~= nil
  local cmd_check = is_wayland and "wl-paste --list-types" or "xclip -selection clipboard -t TARGETS -o"
  local output = vim.fn.system(cmd_check)
  
  if not string.find(output, "image") then
    print("No image in clipboard")
    vim.api.nvim_command("redraw")
    return
  end

  -- Prompt for filename
  local timestamp = os.date("%y%m%d-%H%M%S")
  vim.ui.input({ prompt = "Image name (default: " .. timestamp .. "): " }, function(input)
    if input == nil then return end
    local name = (input == "") and timestamp or input
    local file_name = "images/" .. name .. ".png"
    local full_file_path = file_dir .. "/" .. file_name

    -- Paste image data
    local cmd_paste = is_wayland and "wl-paste --type image/png" or "xclip -selection clipboard -t image/png -o"
    vim.fn.system(cmd_paste .. " > " .. vim.fn.shellescape(full_file_path))
    
    if vim.v.shell_error == 0 then
      -- Insert HTML-style image tag
      local html_snippet = string.format('<img src="./%s" alt="%s" width="200">', file_name, name)
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { html_snippet })
      print("Image pasted to " .. file_name)
    else
      print("Failed to paste image")
    end
    vim.api.nvim_command("redraw")
  end)
end

-- Create a Vim command to invoke the Lua function
vim.api.nvim_create_user_command("PasteImage", paste_image, {})
vim.keymap.set("n", "<Leader>V", paste_image, { noremap = true, silent = true, desc = "Paste image from clipboard" })

-- Function to insert N octothorps followed by a space
local function insert_octothorps(n)
  local octos = string.rep("#", n) .. " "
  vim.api.nvim_put({octos}, "c", true, true)
end

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

-- Custom gf handler for markdown links [text](path)
-------------------------------------------------------------------------------

-- Custom gf handler for markdown links [text](path)
vim.api.nvim_create_augroup("MarkdownGf", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownGf",
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "gf", function()
      local line = vim.fn.getline(".")
      local path_start = line:find("](", 1, true)
      if not path_start then
        vim.cmd("normal! gf")
        return
      end
      path_start = path_start + 2
      local path_end = line:find(")", path_start, true)
      if not path_end then
        vim.cmd("normal! gf")
        return
      end
      local path = line:sub(path_start, path_end - 1)
      local current_file = vim.fn.expand("%:p:h")
      local full_path = vim.fn.fnamemodify(current_file .. "/" .. path, ":p")
      if vim.fn.filereadable(full_path) == 1 then
        vim.cmd("e " .. vim.fn.fnameescape(full_path))
      else
        vim.cmd("normal! gf")
      end
    end, { noremap = true, silent = true, buffer = true })
  end,
})

