-- Ensure local lua modules can be found
package.path = package.path .. ";" .. vim.fn.expand("~/.config/nvim/lua/?.lua") .. ";" .. vim.fn.expand("~/.config/nvim/lua/?/init.lua")

-- ── Core Configurations ──────────────────────────────────────────────────────
require("modules.options")
require("modules.keymaps")
require("modules.theme")

-- ── Feature Modules (comment out any module to disable) ─────────────────────
require("modules.telescope")
require("modules.oil")
require("modules.treesitter")
require("modules.markdown")
require("modules.git")
require("modules.terminal")
require("modules.copilot")
require("modules.helpers")

-- ── Optional Modules (uncomment to enable) ──────────────────────────────────
-- require("modules.encryption")
