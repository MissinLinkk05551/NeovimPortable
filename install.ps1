Write-Output "📦 Installing Neovim config..."
$target = "$env:LOCALAPPDATA\nvim"
git clone https://github.com/MissinLinkk05551/NeovimPortable $target

Write-Output "💤 Installing lazy.nvim..."
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$env:LOCALAPPDATA\nvim-data\lazy\lazy.nvim"

Write-Output "✅ Done! Open Neovim and run :Lazy sync"
