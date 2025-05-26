return
 {
    {
        "feline-nvim/feline.nvim",
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons'
        },
        event = "VeryLazy",
        config = function()
            local one_monokai = {
                fg = "#abb2bf",
                bg = "#1e2024",
                green = "#00FF26",
                yellow = "#FCEC5D",
                purple = "#c678dd",
                orange = "#fe8213",
                peanut = "#f6d5a4",
                red = "#ff0101",
                aqua =  "#00F0FF",
                darkblue = "#282c34",
                dark_red = "#901200",
                minty = "#00FF95",
                lblue = "#1173D9",
            }

            local vi_mode_colors = {
 }

            local mode_map = {
                ["v"] = "V",     -- Visual
                ["V"] = "V-L",   -- Visual Line
                [""] = "V-B",  -- Visual Block
                ["o"] = "OP",    -- Operator Pending
                ["c"] = "CMD",   -- Command
                ["n"] = "N",     -- Normal
                ["i"] = "I",     -- Insert
                ["R"] = "R",     -- Replace
            }

            local c = {
                vim_mode = {
                    provider = {
                        name = "vi_mode",
                        opts = {
                            show_mode_name = true,
                        },
                    },
                    -- provider = function()
                    --     -- Get the current mode
                    --     local mode = vim.api.nvim_get_mode().mode
                    --     -- Map the mode to a custom name or default to the first character
                    --     return mode_map[mode] or mode:sub(1, 1)
                    -- end,
                    hl = function()
                        return {
                            fg = require("feline.providers.vi_mode").get_mode_color(),
                            bg = "bg",
                            style = "bold",
                            name = "NeovimModeHLColor",
                        }
                    end,
                    -- left_sep = "block",
                    -- right_sep = "block",
                },
                -- gitBranch = {
                --     provider = "git_branch",
                --     hl = {
                --         fg = "lblue",
                --         bg = "bg",
                --         style = "bold",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "block",
                -- },
                -- gitDiffAdded = {
                --     provider = "git_diff_added",
                --     hl = {
                --         fg = "green",
                --         bg = "bg",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "block",
                -- },
                -- gitDiffRemoved = {
                --     provider = "git_diff_removed",
                --     hl = {
                --         fg = "red",
                --         bg = "darkblue",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "block",
                -- },
                -- gitDiffChanged = {
                --     provider = "git_diff_changed",
                --     hl = {
                --         fg = "fg",
                --         bg = "darkblue",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "right_filled",
                -- },
                -- separator = {
                --     provider = "",
                -- },
                fileinfo = {
                    provider = {
                        name = "file_info",
                        opts = {
                            type = "short-unique",
                        },
                    },
                    hl = {
                        style = "bold",
                        fg = "minty",
                        bg = "bg",
                    },
                    -- left_sep = " ",
                    -- right_sep = " ",
                },
                -- diagnostic_errors = {
                --     provider = "diagnostic_errors",
                --     hl = {
                --         fg = "red",
                --     },
                -- },
                -- diagnostic_warnings = {
                --     provider = "diagnostic_warnings",
                --     hl = {
                --         fg = "yellow",
                --     },
                -- },
                -- diagnostic_hints = {
                --     provider = "diagnostic_hints",
                --     hl = {
                --         fg = "aqua",
                --     },
                -- },
                -- diagnostic_info = {
                --     provider = "diagnostic_info",
                -- },
                -- lsp_client_names = {
                --     provider = "lsp_client_names",
                --     hl = {
                --         fg = "purple",
                --         bg = "darkblue",
                --         style = "bold",
                --     },
                --     -- left_sep = "block",
                --     right_sep = "right_filled",
                -- },
                -- file_type = {
                --     provider = {
                --         name = "file_type",
                --         opts = {
                --             filetype_icon = true,
                --             case = "titlecase",
                --         },
                --     },
                --     hl = {
                --         fg = "yellow",
                --         bg = "bg",
                --         style = "bold",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "block",
                -- },
                -- file_encoding = {
                --     provider = "file_encoding",
                --     hl = {
                --         fg = "orange",
                --         bg = "darkblue",
                --         style = "italic",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "block",
                -- },
                -- position = {
                --     provider = "position",
                --     hl = {
                --         fg = "green",
                --         bg = "bg",
                --         style = "bold",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "block",
                -- },
                -- line_percentage = {
                --     provider = "line_percentage",
                --     hl = {
                --         fg = "aqua",
                --         bg = "darkblue",
                --         style = "bold",
                --     },
                --     -- left_sep = "block",
                --     -- right_sep = "block",
                -- },
                -- scroll_bar = {
                --     provider = "scroll_bar",
                --     hl = {
                --         fg = "peanut",
                --         style = "bold",
                --     },
                -- },
            }


            local left = {
                c.vim_mode,
                -- c.gitBranch,
                -- c.gitDiffAdded,
                -- c.gitDiffRemoved,
                -- c.gitDiffChanged,
                -- c.lsp_client_names,
                -- c.separator,
            }
            
            local middle = {
                -- c.separator,
                -- c.diagnostic_info,
                -- c.diagnostic_warnings,
                -- c.fileinfo,
                -- c.diagnostic_errors,
                -- c.diagnostic_hints,
                -- c.separator,
            }

            local right = {
                -- c.file_type,
                -- c.file_encoding,
                -- c.position,
                -- c.scroll_bar,
                -- c.line_percentage,
            }

            local components = {
                active = {
                    left,
                    -- middle,
                    -- right,
                },
                inactive = {
                    left,
                    -- middle,
                    -- right,
                },
            }

            require('feline').setup({
                components = components,
                theme = one_monokai,
                vi_mode_colors = vi_mode_colors,
            })
        end
    }
}
