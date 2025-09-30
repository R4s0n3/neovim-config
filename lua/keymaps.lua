-- Global Keymaps and Autocmds

-- NvimTree toggle
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Format buffer (uses LSP for supported files)
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = false })
end, { desc = "Format buffer" })

-- Manual biome format for JS/TS/JSON
vim.keymap.set("n", "<leader>bf", function()
  vim.cmd("!biome format %")
end, { desc = "Biome format" })

-- Manual prisma format
vim.keymap.set("n", "<leader>pf", function()
  vim.cmd("!prisma fmt %")
end, { desc = "Prisma format" })

-- Telescope keymaps with error handling
local telescope_ok, builtin = pcall(require, "telescope.builtin")
if telescope_ok then
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
  vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last search" })
else
  vim.notify("Telescope not available", vim.log.levels.WARN)
end

-- Additional useful keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "<leader>e", ":e<CR>", { desc = "Edit file" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- LSP features
vim.keymap.set("n", "<leader>ih", function()
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
  end
end, { desc = "Toggle inlay hints" })

-- Web development keymaps
vim.keymap.set("i", "<C-y>", "<C-R>=emmet#expandAbbrIntelligent(\"<cr>\")<cr>", { desc = "Emmet expand" })
vim.keymap.set("n", "<leader>cc", ":HighlightColorsToggle<CR>", { desc = "Toggle color highlighting" })

-- LSP management
vim.keymap.set("n", "<leader>li", ":Mason<CR>", { desc = "Open Mason installer" })
vim.keymap.set("n", "<leader>ls", ":LspInfo<CR>", { desc = "Show LSP info" })
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Global Autoformat on Save with error handling
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local ok, _ = pcall(vim.lsp.buf.format, { async = false })
    if not ok then
      vim.notify("LSP formatting failed", vim.log.levels.WARN)
    end
  end,
})