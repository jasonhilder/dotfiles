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
        use {
            "eddyekofo94/gruvbox-flat.nvim",
            config = function()
                require "theme"
            end
        }

        use {
            "nvim-lualine/lualine.nvim",
            after = "gruvbox-flat.nvim",
            config = function()
                require("lualine").setup {
                options = {
                    theme = "gruvbox-flat",
                    section_separators = {''},
                    component_separators = {''}
                    -- ... your lualine config
                }
            }
          end
        }


        use {
            "norcalli/nvim-colorizer.lua",
            event = "BufRead",
            config = function()
                require("plugins.others").colorizer()
            end
        }

        use {
            "kyazdani42/nvim-web-devicons",
            after = "gruvbox-flat.nvim",
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
            "kabouzeid/nvim-lspinstall",
            event = "BufRead"
        }

        use {
            "neovim/nvim-lspconfig",
            after = "nvim-lspinstall",
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

        -- Compe completion
        -- load compe in insert mode only
        use {
            "hrsh7th/nvim-compe",
            event = "InsertEnter",
            config = function()
                require "plugins.compe"
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
            after = "nvim-compe",
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
                require('toggleterm').setup{
                      -- size can be a number or function which is passed the current terminal
                      size = 15,
                      open_mapping = [[<c-\>]],
                      hide_numbers = true, -- hide the number column in toggleterm buffers
                      shade_filetypes = {},
                      shade_terminals = true,
                      shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
                      start_in_insert = true,
                      insert_mappings = true, -- whether or not the open mapping applies in insert mode
                      persist_size = true,
                      direction = 'horizontal',
                      close_on_exit = true, -- close the terminal window when the process exits
                      --shell = vim.o.shell, -- change the default shell
                      -- This field is only relevant if direction is set to 'float'
                      float_opts = {
                        -- The border key is *almost* the same as 'nvim_win_open'
                        -- see :h nvim_win_open for details on borders however
                        -- the 'curved' border is a custom border type
                        -- not natively supported but implemented in this plugin.
                        border = 'single',
                        width = 200,
                        height = 50,
                        winblend = 3,
                        highlights = {
                          border = "Normal",
                          background = "Normal",
                        }
                    }
                }
                -- Lazygit + toggleterm
                local Terminal = require('toggleterm.terminal').Terminal
                local lazygit = Terminal:new({
                    cmd = "lazygit",
                    dir = "git_dir",
                    hidden = true,
                    -- direction = "float",
                    float_opts = {
                        border = "single",
                        width = 200,
                        height = 50,
                    },
                      -- function to run on opening the terminal
                    on_open = function(term)
                        vim.cmd("startinsert!")
                        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
                    end,
                    -- function to run on closing the terminal
                    on_close = function(term)
                        vim.cmd("Closing terminal")
                    end,
                })

                function _lazygit_toggle()
                    lazygit:toggle()
                end
            end
        }

        -- Bufferline
        use {
            'akinsho/bufferline.nvim',
            requires = 'kyazdani42/nvim-web-devicons',
            event = "VimEnter",
            config = function()
                require("bufferline").setup{
                    options = {
                        modified_icon = '•'
                    }
                }
            end
        }

        -- LazyGit
        use {'kdheepak/lazygit.nvim'}

        -- Twig
        use { 'nelsyeung/twig.vim' }

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
