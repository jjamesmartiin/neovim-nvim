local M = {}

function M.recent_files()
  local search_path = vim.fn.expand(vim.g.recent_files_path or vim.fn.getcwd())
  require('telescope.builtin').find_files({
    prompt_title = "Recent Files",
    cwd = search_path,
    find_command = { "sh", "-c", "find " .. vim.fn.shellescape(search_path) .. " -type f -not -path '*/\\.git/*' -printf '%T@ %p\n' | sort -n -r | cut -d' ' -f2-" },
  })
end

function M.current_buffer_fuzzy_find()
  local sorters = require("telescope.sorters")
  require("telescope.builtin").current_buffer_fuzzy_find({
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "bottom", mirror = true },
    sorter = sorters.new({
      scoring_function = function(_, prompt, line)
        if not prompt or prompt == "" then return 0 end
        local l_line = line:lower()
        for word in prompt:lower():gmatch("%S+") do
          if not l_line:find(word, 1, true) then
            return -1
          end
        end
        return 0
      end,
      highlighter = sorters.get_generic_fuzzy_sorter().highlighter,
    }),
    tiebreak = function(current_entry, existing_entry, _)
      return current_entry.lnum < existing_entry.lnum
    end,
  })
end

return M
