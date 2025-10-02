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

	-- Helper function for root_dir
	local function root_pattern(...)
		local patterns = { ... }
		return function(fname)
			local found = vim.fs.find(patterns, { upward = true, path = fname })[1]
			return found and vim.fs.dirname(found) or vim.fn.getcwd()
		end
	end

	-- TypeScript/JavaScript LSP
	vim.lsp.config("ts_ls", {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
		on_attach = on_attach,
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

	-- Tailwind CSS LSP
	vim.lsp.config("tailwindcss", {
		cmd = { "tailwindcss-language-server", "--stdio" },
		filetypes = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"jsx",
			"tsx",
		},
		root_dir = root_pattern(
			"tailwind.config.js",
			"tailwind.config.ts",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"postcss.config.js",
			"postcss.config.ts",
			"package.json",
			".git"
		),
		settings = {
			tailwindCSS = {
				experimental = {
					classRegex = {
						{ "cva\\(([^)]*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },
						{ "cx\\(([^)]*)\\)",   "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "cn\\(([^)]*)\\)",   "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					},
				},
			},
		},
		on_attach = on_attach,
		capabilities = capabilities,
	})

	-- Prisma LSP
	vim.lsp.config("prismals", {
		cmd = { "prisma-language-server", "--stdio" },
		filetypes = { "prisma" },
		root_dir = root_pattern("schema.prisma", ".git", "package.json"),
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			prisma = {
				prismaFmtBinPath = "",
			},
		},
	})

	-- HTML LSP
	vim.lsp.config("html", {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html", "htm" },
		root_dir = root_pattern("package.json", ".git"),
		on_attach = on_attach,
		capabilities = capabilities,
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			provideFormatter = true,
		},
	})

	-- CSS LSP
	vim.lsp.config("cssls", {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "sass", "less" },
		root_dir = root_pattern("package.json", ".git"),
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			css = { validate = true },
			scss = { validate = true },
			less = { validate = true },
		},
	})

	-- JSON LSP
	vim.lsp.config("jsonls", {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_dir = root_pattern(".git"),
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			json = {
				schemas = {
					{
						fileMatch = { "package.json" },
						url = "https://json.schemastore.org/package.json",
					},
					{
						fileMatch = { "tsconfig*.json" },
						url = "https://json.schemastore.org/tsconfig.json",
					},
					{
						fileMatch = { ".eslintrc*.json" },
						url = "https://json.schemastore.org/eslintrc.json",
					},
				},
			},
		},
	})

	-- YAML LSP
	vim.lsp.config("yamlls", {
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml", "yml" },
		root_dir = root_pattern(".git"),
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			yaml = {
				format = { enable = true },
			},
			redhat = {
				telemetry = { enabled = false },
			},
		},
	})

	-- Lua LSP
	vim.lsp.config("lua_ls", {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_dir = root_pattern(
			".luarc.json",
			".luarc.jsonc",
			".luacheckrc",
			".stylua.toml",
			"stylua.toml",
			"selene.toml",
			"selene.yml",
			".git"
		),
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})

	-- Python LSP
	vim.lsp.config("pyright", {
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python" },
		root_dir = root_pattern(
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			"pyrightconfig.json",
			".git"
		),
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
				},
			},
		},
	})

	-- Mason setup with error handling
	local mason_ok, mason = pcall(require, "mason")
	if mason_ok then
		mason.setup()
	end

	local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
	if mason_lsp_ok then
		mason_lsp.setup({
			ensure_installed = {
				"ts_ls",
				"tailwindcss",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"prismals",
				"lua_ls",
				"pyright",
			},
			automatic_installation = true,
		})
	end

	-- nvim-cmp completion with error handling
	local cmp_ok, cmp = pcall(require, "cmp")
	if cmp_ok then
		local luasnip_ok, luasnip = pcall(require, "luasnip")
		if luasnip_ok then
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end
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
