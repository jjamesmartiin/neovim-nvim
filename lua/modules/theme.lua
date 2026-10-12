-- ── Theme Sync (GNOME / Alacritty Light & Dark Mode) ────────────────────────
-- Dark: pure gruvbox (set background=dark)
-- Light: shine + gruvbox (sticky-note style)

local uv = vim.uv or vim.loop

local function get_system_theme()
  -- Check Alacritty's active theme symlink first (instant, 0 fork overhead)
  local path = vim.fn.expand("~/.config/alacritty/theme.toml")
  local target = uv.fs_readlink(path)
  if target then
    if target:find("dark") then return "dark" end
    if target:find("light") then return "light" end
  end

  -- Fallback: query GNOME color-scheme directly
  local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
  if handle then
    local res = handle:read("*a")
    handle:close()
    if res and res:find("prefer%-dark") then
      return "dark"
    end
  end
  return "light"
end

local function apply_theme(mode)
  if mode == "dark" then
    vim.cmd([[
      set background=dark
      colorscheme gruvbox
    ]])
  else
    vim.cmd([[
      colorscheme shine
      set background=light
      colorscheme gruvbox
    ]])
  end
end

-- Apply on Neovim startup
apply_theme(get_system_theme())

-- Event-driven live reloading (0 CPU polling via libuv file watcher)
local alacritty_dir = vim.fn.expand("~/.config/alacritty")
local theme_watcher = uv.new_fs_event()
if theme_watcher then
  theme_watcher:start(alacritty_dir, {}, vim.schedule_wrap(function(err, filename, events)
    if not err then
      apply_theme(get_system_theme())
    end
  end))
end

-- Re-check on focus
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    apply_theme(get_system_theme())
  end,
})
