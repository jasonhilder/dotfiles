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
        -- Yazi file manager in neovim
        ---------------------------------------------------------------------------------
        {
            "mikavilpas/yazi.nvim",
            event = "VeryLazy",
            keys = {
                {
                    "<leader>e",
                    "<cmd>Yazi cwd<cr>",
                    desc = "Open the file manager in nvim's working directory",
                },
            }
        },
        {
            'tpope/vim-fugitive',
            keys = {
                { "<leader>gg", "<cmd>Git<cr>", desc = "Open status manager", },
            }
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
        -- Mini StatusLine
        ---------------------------------------------------------------------------------
        {
            'echasnovski/mini.statusline',
            version = false,
            config = function()
                require('mini.statusline').setup()
            end
        },
        ---------------------------------------------------------------------------------
        -- Treesitter setup
        ---------------------------------------------------------------------------------
        {
            "nvim-treesitter/nvim-treesitter",
            config = function ()
                require'nvim-treesitter.configs'.setup {
                    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
                    ensure_installed = { "c", "lua" },
                    highlight = {
                        enable = true
                    }
                }
            end
        },
        ---------------------------------------------------------------------------------
        -- Colorscheme
        ---------------------------------------------------------------------------------
        { 
            "ellisonleao/gruvbox.nvim", 
            priority = 1000, 
            config = function()
                require("gruvbox").setup({
                    inverse = false,
                    transparent_mode = true,
                    italic = {
                        strings = false,
                        emphasis = false,
                        comments = false,
                        operators = false,
                    },
                })
                vim.cmd.colorscheme('gruvbox')
            end,
        },
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
        -- highlighting text 
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
            keys = {
                {
                    "<leader>tc",
                    "<cmd>HighlightColors Toggle<cr>",
                    desc = "Toggle color code highlighting",
                },
            }
        },
        { 
            "Djancyp/better-comments.nvim",
            config = function()
                require('better-comment').Setup()
            end,
        },
        ---------------------------------------------------------------------------------
        -- LSP Dependencies
        ---------------------------------------------------------------------------------
        {
            "neovim/nvim-lspconfig",
            lazy = true,
            dependencies = {
                { "williamboman/mason.nvim", config = true },
                'williamboman/mason-lspconfig.nvim',
                {
                    'j-hui/fidget.nvim',
                    config = function()
                        require("fidget").setup {}
                    end,
                }
            }
        },
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-nvim-lsp'},
    }
})
