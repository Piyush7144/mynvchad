vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.opt.swapfile = false
vim.opt.wildignore:append {
  "node_modules/*", "dist/*", "build/*", ".git/*", ".venv/*", "*.o", "*.obj"
}
-- Used for Diagnostics popup
vim.opt.updatetime = 250

-- =========================
-- Windows shell
-- =========================
if vim.fn.has("win32") == 1 then
  vim.o.shell         = "pwsh.exe"
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- =========================
-- Diagnostics (single merged config call)
-- =========================
vim.diagnostic.config({
  virtual_text = true,
  float = { border = "rounded", focusable = false, header = "", prefix = "" },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, border = "rounded", scope = "cursor" })
  end,
})


