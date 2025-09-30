-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load modules with error handling
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Failed to load " .. module .. ": " .. result, vim.log.levels.ERROR)
    return false
  end
  return result
end

-- Load configuration modules
safe_require("options")
local plugins = safe_require("plugins")
if plugins then
  require("lazy").setup(plugins)
end
safe_require("lsp")
safe_require("keymaps")

-- Set colorscheme with fallback
pcall(vim.cmd.colorscheme, "rose-pine")
