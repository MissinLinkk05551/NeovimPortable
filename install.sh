#!/usr/bin/env bash
set -e

echo "📦 Installing Neovim config..."
mkdir -p ~/.config/nvim
git clone https://github.com/MissinLinkk05551/NeovimPortable ~/.config/nvim

echo "💤 Installing lazy.nvim..."
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim

echo "✅ Done! Open Neovim and run :Lazy sync"
