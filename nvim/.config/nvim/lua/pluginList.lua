local present, _ = pcall(require, "packerInit")
local packer

if present then
    packer = require "packer"
else
    return false
end

local use = packer.use

return packer.startup(
    function()
        use {
            "wbthomason/packer.nvim",
            event = "VimEnter"
        }

        -- color/ui related stuff
        -- Packer:
        use 'Mofiqul/vscode.nvim'

        use {
            "nvim-lualine/lualine.nvim",
            after = "vscode.nvim",
            config = function()
                require("plugins.others").lualine()
            end
        }

        use {
            "kyazdani42/nvim-web-devicons",
            after = "vscode.nvim",
        }

        use {
            "norcalli/nvim-colorizer.lua",
            event = "BufRead",
            config = function()
                require("plugins.others").colorizer()
            end
        }

        -- Treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
            event = "BufRead",
            config = function()
                require "plugins.treesitter"
            end
        }

        use {
            "nvim-treesitter/nvim-treesitter-textobjects",
            event = "BufRead"
        }

        -- LSP
        use {
            "williamboman/nvim-lsp-installer",
            event = "VimEnter"
        }

        use {
            "neovim/nvim-lspconfig",
            after = "nvim-lsp-installer",
            config = function()
                require "plugins.lspconfig"
            end
        }

        use {
            "onsails/lspkind-nvim",
            event = "BufRead",
            config = function()
                require("plugins.others").lspkind()
            end
        }

        use {
            "ray-x/lsp_signature.nvim",
            after = "nvim-treesitter"
        }

        -- Telescope
         use {
            "nvim-lua/plenary.nvim",
            event = "VimEnter"
        }

        use {
            "nvim-lua/popup.nvim",
            after = "plenary.nvim"
        }

        use {
            "nvim-telescope/telescope.nvim",
            cmd = "Telescope",
            config = function()
                require "plugins.telescope"
            end
        }

        use {
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make",
            cmd = "Telescope"
        }

        use {
            "nvim-telescope/telescope-media-files.nvim",
            cmd = "Telescope"
        }

        -- Cmp completion dependencies
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        -- For luasnip users.
        use 'saadparwaiz1/cmp_luasnip'

        -- cmp for compeletion
        use {
            'hrsh7th/nvim-cmp',
            config = function()
                require "plugins.cmp"
            end,
            wants = "LuaSnip",
            requires = {
                {
                    "L3MON4D3/LuaSnip",
                    wants = "friendly-snippets",
                    event = "InsertCharPre",
                    config = function()
                        require "plugins.luasnip"
                    end
                },
                {
                    "rafamadriz/friendly-snippets",
                    event = "InsertCharPre"
                }
            },
        }


        -- file tree
        use {
            'kyazdani42/nvim-tree.lua',
            requires = 'kyazdani42/nvim-web-devicons',
            config = function()
                require'nvim-tree'.setup {}
            end
        }

        -- git stuff
        use {
            "lewis6991/gitsigns.nvim",
            after = "plenary.nvim",
            config = function()
                require "plugins.gitsigns"
            end
        }

        -- misc plugins
        use {
            "terrortylor/nvim-comment",
            cmd = "CommentToggle",
            config = function()
                require("plugins.others").comment()
            end
        }

        use {
            "max397574/better-escape.nvim",
            event = "InsertEnter",
            config = function()
                require("plugins.others").better_escape()
            end
        }

        use {
            "windwp/nvim-autopairs",
            event = "BufRead",
            config = function()
                require "plugins.autopairs"
            end
        }

        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufRead",
            setup = function()
                require("plugins.others").blankline()
            end
        }

        use {
            "akinsho/nvim-toggleterm.lua",
            event = "VimEnter",
            config = function()
                require "plugins.toggleterm"
            end
        }

        -- Bufferline
        use {
            'akinsho/bufferline.nvim',
            requires = 'kyazdani42/nvim-web-devicons',
            event = "VimEnter",
            config = function()
                require("plugins.others").bufferline()
            end
        }

        -- Vim-wiki
        use {
            'vimwiki/vimwiki',
            config = function()
                vim.g.vimwiki_list = {
                    {
                        path = '~/Mega/docs',
                        syntax = 'markdown',
                        ext = '.md',
                    }
                }
            end
        }

        -- LazyGit
        use {'kdheepak/lazygit.nvim'}

        -- Twig
        -- use { 'nelsyeung/twig.vim' }
        use { 'lumiliet/vim-twig' }

        -- Golang
        -- use { 'fatih/vim-go' }

        -- Rust
        -- use {
        --     'simrat39/rust-tools.nvim',
        --     setup = function()
        --         require("rust-tools").setup({
        --             server = {settings = {["rust-analyzer"] = {checkOnSave = { enable = true }}}}
        --         })
        --     end
        -- }
    end
)
