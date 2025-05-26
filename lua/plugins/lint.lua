return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" }, -- Try to trigger early
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- Ensure these linters are in mason.nvim's `ensure_installed` list
      python = { "flake8" }, -- or {"pylint"}, {"ruff"}
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      lua = { "luacheck" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      yaml = { "yamllint" },
      markdown = { "markdownlint" },
      -- c = { "cppcheck" }, -- requires cppcheck installed
      -- cpp = { "cppcheck" },
      json = { "jsonlint" },
      -- Add more filetypes and their linters
      -- Example:
      -- go = { "golangcilint" },
      -- rust = { "rust-analyzer" }, -- Often LSP provides linting
    }

    -- Create an autocommand to run linting on events.
    local lint_augroup = vim.api.nvim_create_augroup("nvim-lint-autogroup", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function(args)
        -- Avoid linting for non-file buffers or very large files for performance
        if not vim.bo[args.buf].buflisted or vim.bo[args.buf].filetype == '' then
            return
        end
        -- local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf))
        -- if file_size > 500000 then -- 500KB limit, adjust as needed
        --   print("Skipping lint for large file.")
        --   return
        -- end
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Lint: Manually trigger linting" })

    vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Lint: Show error" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Lint: Go to previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Lint: Go to next diagnostic" })

  end,
}