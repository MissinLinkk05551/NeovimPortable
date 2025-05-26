return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-nvim-dap.nvim", -- If you use nvim-dap
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- For other tools like debuggers, linters, formatters
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- A list of servers to automatically install if they're not already installed.
      -- This setting has no relation with the `automatic_installation` setting.
      ensure_installed = {
        -- LSPs
        "lua_ls", -- For Neovim Lua development
        "pyright", -- Python
        "ruff_lsp", -- Python (can replace pylint, flake8, isort, etc.)
        "tsserver", -- TypeScript/JavaScript
        "html", -- HTML
        "cssls", -- CSS
        "emmet_ls", -- Emmet for HTML/CSS
        "tailwindcss", -- TailwindCSS
        "jsonls", -- JSON
        "yamlls", -- YAML
        "bashls", -- Bash/Shell scripts
        "dockerls", -- Dockerfile
        "marksman", -- Markdown
        "gopls", -- Go
        "rust_analyzer", -- Rust
        "clangd", -- C/C++ (ensure you have clangd installed or it can build it)
        -- "jdtls", -- Java (requires more setup)
        -- "csharp_ls", -- C# (Omnisharp)
        -- "phpactor", -- PHP
        -- "powershell_es", -- PowerShell
      },
      -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
      -- This setting has no relation with the `ensure_installed` setting.
      -- Can be an empty list, or list of server names to install automatically.
      -- Or 'true' to install all configured servers.
      -- Or 'false' to disable.
      automatic_installation = true,
    })

    -- This setup is for tools beyond LSPs (linters, formatters, DAPs)
    -- mason-nvim-dap handles DAP installations within its own setup.
    -- This is for other tools like standalone linters and formatters.
    mason_tool_installer.setup({
      ensure_installed = {
        -- Formatters
        "stylua", -- Lua
        "prettierd", -- JS/TS/JSON/MD/YAML/CSS/HTML (daemonized for speed)
        -- "prettier", -- Alternative to prettierd
        "black", -- Python
        "isort", -- Python import sorting (ruff can also do this)
        "shfmt", -- Shell scripts
        "gofumpt", -- Go
        "goimports", -- Go (also does imports)
        "clang-format", -- C/C++

        -- Linters (some LSPs provide linting, these are standalone)
        "flake8", -- Python (can be replaced by ruff)
        "shellcheck", -- Shell scripts
        "yamllint", -- YAML
        "markdownlint-cli", -- Markdown (for nvim-lint)
        "luacheck", -- Lua
        "eslint_d", -- JS/TS (daemonized for speed)

        -- Debug Adapters (also managed by mason-nvim-dap, but listing here is fine for visibility)
        "debugpy", -- Python
        "codelldb", -- C, C++, Rust (LLDB based)
        -- "cpptools", -- C, C++ (VSCode C++ tools debugger)
        "delve", -- Go
        -- "node-debug2-adapter", -- Node.js
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}