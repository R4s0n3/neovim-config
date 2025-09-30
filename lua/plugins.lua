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
        -- Web Development
        "lua",
        "typescript",
        "javascript",
        "tsx",
        "html",
        "css",
        "scss",
        "json",
        "yaml",
        "prisma",
        
        -- General Purpose
        "python",
        "go",
        "rust",
        "c",
        "cpp",
        "java",
        "kotlin",
        "php",
        "ruby",
        
        -- Markup & Config
        "markdown",
        "toml",
        "dockerfile",
        "gitignore",
        "gitcommit",
        "git_rebase",
        "diff",
        
        -- Shell & Scripting
        "bash",
        "fish",
      },
      highlight = { enable = true },
      indent = { enable = true },
      autotag = { enable = true }, -- Auto-close HTML/JSX tags
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },

  -- Prisma Vim plugin fallback
  { "pantharshit00/vim-prisma" },

  -- Auto-close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Emmet for HTML/CSS
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "scss", "javascript", "typescript", "jsx", "tsx" },
  },

  -- Better CSS support
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        enable_named_colors = true,
        enable_tailwind = true,
      })
    end,
  },

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