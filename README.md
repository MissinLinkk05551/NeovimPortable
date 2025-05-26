# ✨ MissinLinkk's Portable Neovim Config

This is a **portable, fast, and fully-featured Neovim config** that works across Windows, Linux, and macOS.

## 🔧 Features
- 🧠 Smart line comments (`<leader>/`)
- 🧮 Increment/Decrement/Reorder numbers (`<C-a>`, `<C-x>`)
- 🅰️ Surround editing with `nvim-surround`
- 🖱️ Multiple cursors via `vim-visual-multi`
- 💡 Lazy-loaded plugins via `lazy.nvim`

## 🚀 Quick Setup

### Linux/macOS
```bash
bash <(curl -s https://raw.githubusercontent.com/MissinLinkk05551/NeovimPortable/main/install.sh)
nvim +Lazy sync
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/MissinLinkk05551/NeovimPortable/main/install.ps1 | iex
```

## ⌨️ Keybindings
| Feature         | Mode | Mapping       |
|----------------|------|---------------|
| Comment line    | n/v  | `<leader>/`   |
| Increment       | n/v  | `<C-a>`       |
| Decrement       | n/v  | `<C-x>`       |
| Visual multi    | v    | `<C-n>`       |

## 🗃 Dotfile Management
Clone and symlink or use tools like `chezmoi`, `stow`, or `yadm` for dotfile management.



# NeovimPortable - A Cross-Platform Neovim Configuration

This repository contains a portable Neovim configuration designed to be easily used across different machines (Windows, Linux, macOS). It uses `lazy.nvim` for plugin management and aims for a modern, efficient Neovim experience.

## Features

*   **Plugin Management:** Uses `lazy.nvim` for fast and declarative plugin management.
*   **LSP Integration:** Ready for Language Server Protocol via `nvim-lspconfig` and `mason.nvim` for easy LSP installation.
*   **Syntax Highlighting:** Enhanced with `nvim-treesitter`.
*   **File Explorer:** `nvim-tree.lua`.
*   **Fuzzy Finding:** `telescope.nvim`.
*   **Statusline & Tabline:** `lualine.nvim` and `bufferline.nvim`.
*   **Auto-completion:** `nvim-cmp`.
*   **Formatting:** `conform.nvim`.
*   **Linting:** `nvim-lint`.
*   **Debugging:** `nvim-dap` and `nvim-dap-ui`.
*   **Git Integration:** `gitsigns.nvim`.
*   And many more useful plugins for a productive development environment.

## Prerequisites

1.  **Neovim:** Version 0.9+ installed.
    *   [Neovim Releases](https://github.com/neovim/neovim/releases)
    *   Consider a version manager like [bob](https://github.com/MordechaiHadad/bob).
2.  **Git:** Required for cloning this repository and for plugin management.
3.  **Nerd Font:** **Highly Recommended** for icons and UI elements.
    *   Download and install a Nerd Font (e.g., FiraCode Nerd Font, JetBrainsMono Nerd Font, Hack Nerd Font) from [nerdfonts.com](https://www.nerdfonts.com/).
    *   Configure your terminal emulator to use the installed Nerd Font.
4.  **Basic Build Tools:** (Optional, but recommended for some Mason packages)
    *   **Linux:** `build-essential` (Debian/Ubuntu), `base-devel` (Arch), `Development Tools` (Fedora).
    *   **macOS:** Xcode Command Line Tools (`xcode-select --install`).
    *   **Windows:** MSVC Build Tools (usually comes with Visual Studio Installer -> Build Tools SKU or C++ Desktop Development workload).
5.  **System-Specific Tools (Handled by setup scripts):**
    *   `curl`, `unzip`
    *   `ripgrep` (rg)
    *   `fd` (fd-find)
    *   **Windows:** `winget` (App Installer from Microsoft Store). PowerShell 5.1+ (PowerShell Core 7+ `pwsh` is preferred).

## Setup Instructions

1.  **Clone this repository:**
    *   The setup scripts below will handle cloning this configuration to the correct Neovim config directory.
    *   Linux/macOS: `~/.config/nvim`
    *   Windows: `%LOCALAPPDATA%\nvim` (e.g., `C:\Users\YourUser\AppData\Local\nvim`)

2.  **Run the setup script for your OS:**

    *   **For Linux/macOS:**
        ```bash
        # Download the script
        curl -LO https://raw.githubusercontent.com/MissinLinkk05551/NeovimPortable/main/setup.sh
        # Make it executable
        chmod +x setup.sh
        # Run it
        ./setup.sh
        ```
        *(Alternatively, clone the repo first, then cd into it and run `./setup.sh`)*

    *   **For Windows (using PowerShell):**
        ```powershell
        # Open PowerShell (preferably as Administrator if you don't have winget packages installed)
        # Download and execute the script:
        Invoke-RestMethod -Uri https://raw.githubusercontent.com/MissinLinkk05551/NeovimPortable/main/setup.ps1 | Invoke-Expression
        ```
        *(Alternatively, clone the repo first, then navigate into it in PowerShell and run `.\setup.ps1`)*

3.  **First Launch:**
    *   Open Neovim (`nvim`).
    *   `lazy.nvim` will automatically start installing plugins. This might take a few minutes.
    *   `mason.nvim` will then attempt to install the LSPs, linters, formatters, and debug adapters specified in the configuration. You can check the progress with `:Mason`.
    *   If you encounter any issues, check `:checkhealth` for diagnostics.

## Customization

*   **Plugins:** Add or remove plugins in files within the `lua/plugins/` directory. `lazy.nvim` will automatically pick them up.
*   **Keymaps:** Global keymaps are in `lua/core/keymaps.lua`. Plugin-specific keymaps are usually within their respective plugin files in `lua/plugins/`.
*   **Options:** Core Neovim options are in `lua/core/options.lua`.

## Troubleshooting

*   **Icons not showing:** Ensure you have a Nerd Font installed AND configured in your terminal emulator.
*   **Mason errors:** Some tools installed by Mason might have system dependencies (e.g., a C compiler for tree-sitter parsers, Node.js for some LSPs). The setup scripts try to cover common ones. Check Mason's output or `:checkhealth mason.nvim`.
*   **LSP not attaching:** Run `:LspInfo` to see the status of language servers for the current buffer. Check `:Mason` to ensure the required LSP is installed.

Enjoy your portable Neovim setup!