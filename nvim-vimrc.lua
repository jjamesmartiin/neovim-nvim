-- Backward-compatibility entrypoint: loads the modular init.lua
local uv = vim.uv or vim.loop
local raw_source = debug.getinfo(1, "S").source:sub(2)
local real_path = uv.fs_realpath(raw_source) or raw_source
local config_dir = vim.fn.fnamemodify(real_path, ":p:h")
dofile(config_dir .. "/init.lua")
