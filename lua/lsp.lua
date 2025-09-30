local M = {}

function M.setup()
  local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    
    -- Key mappings
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    
    -- Disable formatting for clients that don't support it
    if client.supports_method("textDocument/formatting") then
      client.server_capabilities.documentFormattingProvider = true
    else
      client.server_capabilities.documentFormattingProvider = false
    end
  end

  -- Check if cmp_nvim_lsp is available
  local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if not cmp_lsp_ok then
    vim.notify("cmp_nvim_lsp not available, using basic capabilities", vim.log.levels.WARN)
    return
  end

  local capabilities = cmp_lsp.default_capabilities()
  
  -- Add modern LSP capabilities
  capabilities.textDocument.inlayHint = {
    dynamicRegistration = false,
    resolveSupport = {
      properties = {}
    }
  }

  -- LSP servers using modern vim.lsp.config API
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = vim.fs.dirname(vim.fs.find({ "package.json", "tsconfig.json", ".git" }, { upward = true })[1]),
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- Enable inlay hints for TypeScript
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(bufnr, true)
      end
    end,
    capabilities = capabilities,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  })

  vim.lsp.config("tailwindcss", {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = { "html", "css", "scss", "javascript", "typescript", "jsx", "tsx" },
    root_dir = vim.fs.dirname(vim.fs.find({ "tailwind.config.*", "postcss.config.*", ".git" }, { upward = true })[1]),
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.config("prismals", {
    cmd = { "prisma-language-server", "--stdio" },
    filetypes = { "prisma" },
    root_dir = vim.fs.dirname(vim.fs.find({ "prisma/schema.prisma", ".git" }, { upward = true })[1]),
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Mason setup with error handling
  local mason_ok, mason = pcall(require, "mason")
  if mason_ok then
    mason.setup()
  end

  local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
  if mason_lsp_ok then
    mason_lsp.setup({
      ensure_installed = { "ts_ls", "tailwindcss", "prismals" },
    })
  end

-- Formatting handled via LSP and manual commands

  -- nvim-cmp completion with error handling
  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok then
    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if luasnip_ok then
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, { { name = "buffer" } }),
      })
    else
      vim.notify("LuaSnip not available, using basic completion", vim.log.levels.WARN)
    end
  else
    vim.notify("nvim-cmp not available", vim.log.levels.WARN)
  end

  -- nvim-lint (fallback for Biome warnings)
  local lint_ok, lint = pcall(require, "lint")
  if lint_ok then
    lint.linters_by_ft = {
      javascript = { "biome" },
      typescript = { "biome" },
      json = { "biome" },
    }
  end
end

return M