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
