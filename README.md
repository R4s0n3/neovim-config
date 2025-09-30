# Neovim Configuration

A modern Neovim configuration built with Lua and lazy.nvim for efficient plugin management.

## Features

- **Plugin Management**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and efficient plugin loading
- **LSP Support**: Modern LSP configuration for TypeScript, Tailwind CSS, and Prisma with auto-completion and inlay hints
- **File Explorer**: Nvim-tree for file navigation
- **Fuzzy Finder**: Telescope for file searching and live grep
- **Syntax Highlighting**: Treesitter with support for multiple languages
- **Code Formatting**: Built-in LSP formatting with manual Biome and Prisma formatting
- **Modern UI**: Rose-pine colorscheme with transparency support

## Prerequisites

- Neovim 0.8+ 
- Git
- Node.js (for LSP servers)
- The following tools for formatting:
  - [Biome](https://biomejs.dev/) for JavaScript/TypeScript/JSON
  - [Prisma CLI](https://www.prisma.io/docs/concepts/components/prisma-cli) for Prisma files

## Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   cd ~/.config/nvim
   ```

2. Install the required tools:
   ```bash
   # Install Biome
   npm install -g @biomejs/biome
   
   # Install Prisma CLI
   npm install -g prisma
   ```

3. Start Neovim and let lazy.nvim install all plugins:
   ```bash
   nvim
   ```

4. The first time you start Neovim, it will automatically:
   - Install lazy.nvim
   - Download and configure all plugins
   - Install LSP servers via Mason

## Key Bindings

### General
- `<Space>` - Leader key
- `<C-n>` - Toggle file tree (NvimTree)

### File Operations
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Find buffers (Telescope)
- `<leader>fh` - Help tags (Telescope)

### Code Actions
- `<leader>f` - Format buffer (LSP)
- `<leader>bf` - Biome format (manual)
- `<leader>pf` - Prisma format (manual)

### LSP
- `K` - Hover documentation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Go to references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format buffer
- `<leader>ih` - Toggle inlay hints

## Configuration Structure

```
~/.config/nvim/
├── init.lua              # Main entry point
├── lazy-lock.json        # Plugin versions lock file
├── .gitignore           # Git ignore rules
├── README.md            # This file
└── lua/
    ├── options.lua      # Neovim options and settings
    ├── keymaps.lua      # Key mappings
    ├── plugins.lua      # Plugin configurations
    └── lsp.lua          # LSP and completion setup
```

## Supported Languages

- Lua
- TypeScript/JavaScript
- JSON
- YAML
- Prisma
- HTML/CSS (with Tailwind CSS support)

## Customization

### Adding New Plugins
Edit `lua/plugins.lua` to add new plugins. The configuration uses lazy.nvim's plugin specification format.

### Modifying Key Bindings
Edit `lua/keymaps.lua` to add or modify key mappings.

### LSP Configuration
Edit `lua/lsp.lua` to add new language servers or modify existing ones.

## Troubleshooting

### LSP Issues
If LSP features aren't working:
1. Check that the language server is installed: `:Mason`
2. Verify the server is running: `:LspInfo`
3. Check LSP logs: `:LspLog`

### Plugin Issues
If plugins aren't loading:
1. Check lazy.nvim status: `:Lazy`
2. Sync plugins: `:Lazy sync`
3. Check for errors: `:Lazy log`

### Formatting Issues
- For JavaScript/TypeScript: Ensure Biome is installed and in PATH
- For Prisma: Ensure Prisma CLI is installed and in PATH

## License

This configuration is provided as-is for personal use. Feel free to fork and modify as needed.
