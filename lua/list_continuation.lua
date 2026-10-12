local M = {}

function M.handle_enter()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)
  local after_cursor = line:sub(col + 1)
  
  -- Patterns for different list types
  -- 1. Checkbox lists: - [ ], * [ ], _ [ ]
  local indent, marker = before_cursor:match("^(%s*)([%*%-_]%s*%[%s*[x ]%s*%]%s*)")
  if marker then
    -- If the current item is empty and we're at the end of the line, clear it
    if before_cursor:match("^%s*[%*%-_]%s*%[%s*[x ]%s*%]%s*$") and after_cursor == "" then
      return vim.api.nvim_replace_termcodes("<C-u>0<C-d>", true, false, true)
    end
    -- Otherwise, continue the list with an empty checkbox
    local new_marker = marker:gsub("%[x%]", "[ ]")
    return vim.api.nvim_replace_termcodes("<CR>0<C-d>", true, false, true) .. indent .. new_marker
  end

  -- 2. Ordered lists: 1. 
  indent, marker = before_cursor:match("^(%s*)(%d+%.%s+)")
  if marker then
    if before_cursor:match("^%s*%d+%.%s*$") and after_cursor == "" then
      return vim.api.nvim_replace_termcodes("<C-u>0<C-d>", true, false, true)
    end
    local num = marker:match("%d+")
    local next_num = tonumber(num) + 1
    local sep = marker:match("%.%s+")
    return vim.api.nvim_replace_termcodes("<CR>0<C-d>", true, false, true) .. indent .. next_num .. sep
  end

  -- 3. Simple bullets: *, -, _, +
  indent, marker = before_cursor:match("^(%s*)([*%-_+]%s+)")
  if marker then
    if before_cursor:match("^%s*[*%-_+]%s*$") and after_cursor == "" then
      return vim.api.nvim_replace_termcodes("<C-u>0<C-d>", true, false, true)
    end
    return vim.api.nvim_replace_termcodes("<CR>0<C-d>", true, false, true) .. indent .. marker
  end

  return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
end

return M
