return {
  -- Colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "",
      terminal_colors = true,
      styles = { transparency = true, italic = false },
    },
    config = function(_, opts) require("rose-pine").setup(opts) end,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { side = "right" },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "typescript",
        "javascript",
        "json",
        "yaml",
        "prisma",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },

  -- Prisma Vim plugin fallback
  { "pantharshit00/vim-prisma" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", "%.git/" },
        },
      })
-- Load extensions if installed
      -- pcall(require("telescope").load_extension, "ui-select")
    end,
  },

  -- LSP + Completion + Formatting/Linting
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Completion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Formatting / Linting
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-lint",
    },
    config = function()
      require("lsp").setup()
    end,
  },

}