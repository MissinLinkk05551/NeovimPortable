return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- Dependency for nvim-dap-ui
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim", -- Bridges Mason and nvim-dap
      "theHamsta/nvim-dap-virtual-text", -- Show debug info in virtual text
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_virtual_text = require("nvim-dap-virtual-text")

      -- Setup for mason-nvim-dap
      -- This will ensure that the debug adapters are installed through Mason
      require("mason-nvim-dap").setup({
        ensure_installed = {
          -- Add your desired debug adapters here
          "debugpy",     -- Python
          "codelldb",    -- C, C++, Rust (via LLDB)
          -- "cpptools", -- Alternative for C, C++ (from VS Code)
          "delve",       -- Go
          -- "node-debug2-adapter", -- Node.js (might need node2 if this doesn't work for older projects)
        },
        -- Automatic setup of configurations for installed adapters
        automatic_installation = true, -- Install DAPs if not found when trying to use them
        handlers = {}, -- Let mason-nvim-dap handle the setup
      })

      -- nvim-dap-virtual-text setup
      dap_virtual_text.setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = "<handler",
        -- experimental features:
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- nvim-dap-ui setup
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "󰝚" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7"),
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks", size = 0.20 },
              { id = "watches", size = 0.25 },
            },
            size = 0.33, -- Width of the entire DAP UI sidebar
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 0.25, -- Height of the bottom DAP UI panel
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single", -- "single", "double", "rounded", "solid"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        }
      })

      -- Toggle DAP UI visibility when a debug session starts/ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Python specific configuration (using debugpy)
      -- dap.adapters.python = {
      --   type = "executable",
      --   command = vim.fn.stdpath("data") .. "/mason/bin/python-debug-adapter", -- Managed by mason-nvim-dap
      --   -- If mason-nvim-dap doesn't set this up for you, you might need:
      --   -- command = "/path/to/virtualenv/bin/python", -- Path to python executable with debugpy
      --   -- args = { "-m", "debugpy.adapter" },
      -- }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Ensure mason-nvim-dap has installed debugpy correctly
            -- Or provide a path to your venv python
            local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
            if vim.fn.isdirectory(mason_path .. "packages/debugpy/venv/bin/") then
                return mason_path .. "packages/debugpy/venv/bin/python"
            end
            -- Fallback if you have a .venv in the project
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/.venv/bin/python") then
              return cwd .. "/.venv/bin/python"
            end
            return vim.fn.input("Path to python executable: ", "python", "file")
          end,
          console = "integratedTerminal", -- "internalConsole", "integratedTerminal", "externalTerminal"
          justMyCode = true, -- Step through user-written code only.
        },
        {
            type = "python",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            justMyCode = true,
        },
      }

      -- C/C++/Rust specific configuration (using codelldb)
      -- dap.adapters.codelldb = { -- This is often handled by mason-nvim-dap
      --   type = "server",
      --   port = "${port}",
      --   executable = {
      --     command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      --     args = { "--port", "${port}" },
      --   },
      -- }

      dap.configurations.cpp = {
        {
          name = "Launch file (C++/C/Rust with codelldb)",
          type = "codelldb", -- This must match the adapter name registered by mason-nvim-dap
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          console = "integratedTerminal",
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp


      -- General DAP Keymaps
      vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "DAP: Set Conditional Breakpoint" })
      vim.keymap.set("n", "<Leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "DAP: Set Log Point" })

      vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "DAP: Continue" })
      vim.keymap.set("n", "<Leader>dj", dap.step_over, { desc = "DAP: Step Over (Next)" }) -- j for next line
      vim.keymap.set("n", "<Leader>dk", dap.step_into, { desc = "DAP: Step Into" })     -- k for into
      vim.keymap.set("n", "<Leader>du", dap.step_out, { desc = "DAP: Step Out" })      -- u for up/out
      vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
      vim.keymap.set("n", "<Leader>do", function() dapui.toggle() end, { desc = "DAP: Toggle UI" }) -- o for open/toggle UI
      vim.keymap.set("n", "<Leader>dq", function() dap.terminate() dapui.close() end, { desc = "DAP: Quit Session" })

      vim.keymap.set("n", "<Leader>dsc", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })
      vim.keymap.set("n", "<Leader>dsv", function() require('dap.variables').scopes() end, { desc = "DAP: View Scopes (deprecated by UI)" })
      vim.keymap.set("n", "<Leader>dsw", function() require('dapui').eval() end, { desc = "DAP: Add to Watch / Eval" })
      vim.keymap.set("n", "<Leader>dsr", dap.restart, { desc = "DAP: Restart Session" })
    end,
  },
}