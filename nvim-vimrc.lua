-- Backward-compatibility entrypoint: loads the modular init.lua
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
dofile(config_dir .. "/init.lua")
