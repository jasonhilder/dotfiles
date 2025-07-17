-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            "vague2k/vague.nvim",
            config = function()
                vim.cmd("colorscheme vague")

                -- Base background overrides
                local bg = "#111111"
                vim.api.nvim_set_hl(0, "Normal", { bg = bg })
                vim.api.nvim_set_hl(0, "NormalNC", { bg = bg })
                vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
                vim.api.nvim_set_hl(0, "VertSplit", { bg = bg })
                vim.api.nvim_set_hl(0, "StatusLine", { bg = bg })
                -- Floating windows / pickers
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
                vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg })
                -- fzf-lua specific
                vim.api.nvim_set_hl(0, "FzfLuaBorder", { bg = bg })
                vim.api.nvim_set_hl(0, "FzfLuaNormal", { bg = bg })
                vim.api.nvim_set_hl(0, "FzfLuaTitle", { bg = bg, fg = "#aaaaaa" })
            end
        },
        ---------------------------------------------------------------------------------
        -- Multiple fzf pickers
        ---------------------------------------------------------------------------------
        {
            "ibhagwan/fzf-lua",
            event = "BufEnter",
            config = function()
                require("fzf-lua").setup({})
            end,
            keys = {
                { "<leader><leader>", "<cmd>lua require'fzf-lua'.files({ cmd = vim.env.FZF_DEFAULT_COMMAND })<cr>", desc = "Fzf files", },
                { "<leader>b", "<cmd>FzfLua buffers<cr>", desc = "Fzf buffers", },
                { "<leader>m", "<cmd>FzfLua keymaps<cr>", desc = "Fzf keymaps", },
                { "<leader>s", "<cmd>FzfLua grep_project<cr>", desc = "Fzf keymaps", },
                { "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer diagnostics", },
                { "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Project diagnostics", },
            }
        },
        ---------------------------------------------------------------------------------
        -- Git client
        ---------------------------------------------------------------------------------
        {
            'tpope/vim-fugitive',
            keys = {
                { "<leader>gg", "<cmd>Git<cr>", desc = "Open status manager", },
            }
        },
        ---------------------------------------------------------------------------------
        -- Mini filemanager
        ---------------------------------------------------------------------------------
        { 
            'echasnovski/mini.files', 
            version = '*',
            keys = {
                { "<leader>e", "<cmd>lua MiniFiles.open()<cr>", desc = "Open status manager", },
            },
            config = function()
                require('mini.files').setup()
            end
        },
        ---------------------------------------------------------------------------------
        -- Mini comment: Comment code blocks
        ---------------------------------------------------------------------------------
        {
            'echasnovski/mini.comment',
            version = false,
            config = function()
                require('mini.comment').setup()
            end
        },
        ---------------------------------------------------------------------------------
        -- Mini Surround: surround selects "''"
        ---------------------------------------------------------------------------------
        {
            'echasnovski/mini.surround',
            event = "BufEnter",
            version = "*",
            config = function()
                require("mini.surround").setup({})
            end
        },
        ---------------------------------------------------------------------------------
        -- Add indentation guides
        ---------------------------------------------------------------------------------
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {
                indent = { highlight = { "LineNr" }, char = "│" },
                scope = { enabled = false },
            }
        },
        ---------------------------------------------------------------------------------
        -- Treesitter setup
        ---------------------------------------------------------------------------------
        {
            "nvim-treesitter/nvim-treesitter",
            config = function ()
                require'nvim-treesitter.configs'.setup {
                    ensure_installed = { "c", "lua", "go" },
                    highlight = { enable = true }
                }
            end
        },
        ---------------------------------------------------------------------------------
        -- tmux in vim
        ---------------------------------------------------------------------------------
        { 
            'alexghergh/nvim-tmux-navigation', 

            config = function()
                local nvim_tmux_nav = require('nvim-tmux-navigation')

                nvim_tmux_nav.setup {
                    disable_when_zoomed = true -- defaults to false
                }

                vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
                vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
                vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
                vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
                vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
                vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
            end
        },
        ---------------------------------------------------------------------------------
        -- highlighting text (colors,comments)
        ---------------------------------------------------------------------------------
        {
            'brenoprata10/nvim-highlight-colors',
            event = 'BufEnter',
            config = function()
                require('nvim-highlight-colors').setup({})
                vim.cmd [[ 
                HighlightColors Toggle
                ]]
            end,
            keys = {{ "<leader>tc", "<cmd>HighlightColors Toggle<cr>", desc = "Toggle color highlighting" }}
        },
        { 
            "Djancyp/better-comments.nvim",
            config = function()
                require('better-comment').Setup({
                    tags = {
                        { name = "TODO", bg = "", fg = "#0a7aca" },
                        { name = "NOTE", bg = "", fg = "#32cd36" },
                        { name = "FIX", bg = "", fg = "#f44747" },
                        { name = "WARN", bg = "", fg ="#FFA500" }
                    }
                })
            end,
        },
        ---------------------------------------------------------------------------------
        -- LSP Dependencies
        ---------------------------------------------------------------------------------
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-nvim-lsp'},
    }
})
