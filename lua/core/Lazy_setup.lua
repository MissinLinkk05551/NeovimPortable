local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- All plugins are imported from the lua/plugins directory
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- By default, the colorscheme is set in plugins/tokyonight.lua
  -- ui = {
  --   border = "rounded", -- Example: set border style for Lazy UI
  -- },
  performance = {
    rtp = {
      -- disable some rtp plugins, true is
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  checker = {
    enabled = true,
    notify = true, -- Notify when new updates are available
  },
  change_detection = {
    enabled = true,
    notify = true, -- Notify when changes are detected (e.g., git head changed)
  },
})

-- Load custom autocommands after plugins are set up
-- For example, to clear search highlighting on move
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  command = "set norelativenumber",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set relativenumber",
})

-- Clear search highlighting on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')