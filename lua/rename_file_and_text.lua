-- Usage:
-- 1. Trigger via :lua require('rename_file_and_text').rename_and_refactor()
--    (Usually mapped to <Leader>rf)
-- 2. Select the file you want to rename in the Telescope picker.
-- 3. Type the new name for the file in the prompt.
-- 4. The tool will rename the file and then open a second Telescope picker 
--    showing every place that the old filename is mentioned in your project.
-- 5. By default, all occurrences are selected. Use <Space> to toggle individual 
--    items if there are references you don't want to update.
-- 6. Press <Enter> to perform the bulk replacement of the text in all selected files.

local M = {}

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

-- Helper to perform the bulk replacement
local function execute_replacement(selections, old_str, new_str)
  local count = 0
  local files_affected = {}

  for _, entry in ipairs(selections) do
    local file = entry.filename or entry.path
    local lnum = entry.lnum
    
    -- Load file into buffer if not already loaded
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)
    
    local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
    if lines[1] then
      -- Escape special characters for Lua pattern matching
      local escaped_old = old_str:gsub("([^%w])", "%%%1")
      -- Use gsub with count to track total replacements on this line
      local new_line, replacements = lines[1]:gsub(escaped_old, new_str)
      
      if replacements > 0 then
        vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { new_line })
        -- Save the buffer
        vim.api.nvim_buf_call(bufnr, function() vim.cmd("w") end)
        count = count + replacements
        files_affected[file] = true
      end
    end
  end

  local file_count = 0
  for _ in pairs(files_affected) do file_count = file_count + 1 end
  
  vim.notify(string.format("Refactor complete: %d occurrences replaced in %d files.", count, file_count), vim.log.levels.INFO)
end

function M.rename_and_refactor()
  -- 1. Pick a file to rename
  builtin.find_files({
    prompt_title = "Refactor: Select File to Rename",
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        local old_path = selection.path or selection[1]
        local old_name = vim.fn.fnamemodify(old_path, ":t")
        local old_dir = vim.fn.fnamemodify(old_path, ":h")
        
        -- 2. Prompt for new filename
        vim.ui.input({
          prompt = "Rename '" .. old_name .. "' to: ",
          default = old_name,
        }, function(new_name)
          if not new_name or new_name == "" or new_name == old_name then
            return
          end
          
          local new_path = old_dir .. "/" .. new_name
          
          -- Perform the actual file rename
          local success, err = os.rename(old_path, new_path)
          if not success then
            vim.notify("Error renaming file: " .. err, vim.log.levels.ERROR)
            return
          end
          
          -- 3. Search for occurrences of OLD name in the project
          builtin.grep_string({
            search = old_name,
            prompt_title = "Refactor: " .. old_name .. " -> " .. new_name .. " (Space=toggle, Enter=Apply)",
            attach_mappings = function(grep_bufnr, grep_map)
              -- Map Space to toggle selection
              grep_map("i", "<Space>", actions.toggle_selection)
              grep_map("n", "<Space>", actions.toggle_selection)
              
              -- Pre-select everything by default (visual feedback)
              -- Using a delay and explicit checks to avoid initialization race conditions
              vim.defer_fn(function()
                if not vim.api.nvim_buf_is_valid(grep_bufnr) then return end
                
                local picker = action_state.get_current_picker(grep_bufnr)
                -- Only call toggle_all if the picker and its manager are actually ready
                if picker and type(picker.manager) == "table" then
                  pcall(actions.toggle_all, grep_bufnr)
                end
              end, 250)
              
              -- 4. Map Enter to execute replacement on selected items
              actions.select_default:replace(function()
                local picker = action_state.get_current_picker(grep_bufnr)
                if not picker then 
                   actions.close(grep_bufnr)
                   return 
                end

                local selections = picker:get_multi_selection()
                
                -- Fallback: If no manual selections were made, take all entries from the picker
                if vim.tbl_isempty(selections) then
                  selections = {}
                  -- Ensure manager exists before iterating
                  if picker.manager and type(picker.manager) == "table" then
                    for entry in picker.manager:iter() do
                      table.insert(selections, entry)
                    end
                  end
                end
                
                if vim.tbl_isempty(selections) then
                   print("No items found for replacement.")
                   actions.close(grep_bufnr)
                   return
                end
                
                actions.close(grep_bufnr)
                execute_replacement(selections, old_name, new_name)
              end)
              
              return true
            end,
          })
        end)
      end)
      return true
    end,
  })
end

return M
