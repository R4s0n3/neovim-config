local M = {}

M.patterns = {
	"*/.DS_Store", ".DS_Store",
}

-- 1. Configure global wildignore for built-in features
vim.opt.wildignore:append(table.concat(M.patterns, ","))

-- 2. Configure netrw for the built-in file explorer
local netrw_hide_pattern = table.concat(M.patterns, ",") .. ",\\.\\S+"
vim.g.netrw_list_hide = netrw_hide_pattern

return M
