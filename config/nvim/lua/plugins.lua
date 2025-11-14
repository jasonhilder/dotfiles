require("paq")({
	"savq/paq-nvim",
    "nvim-lua/plenary.nvim",
    "akinsho/toggleterm.nvim",
    -- Pickers and tooling
    "nvim-telescope/telescope.nvim",
    "NeogitOrg/neogit",
    "sindrets/diffview.nvim",
    "karb94/neoscroll.nvim",
    "folke/which-key.nvim",
    "lmburns/lf.nvim",
    -- UI additions
    "rebelot/kanagawa.nvim",
    "nvim-treesitter/nvim-treesitter",
    "lukas-reineke/indent-blankline.nvim",
    "nvim-mini/mini.statusline",
    -- Auto complete, snippets
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer"
})

vim.g.vimwiki_list = { { path = '~/Documents/wiki/' } }

require('lf').setup({
    height = vim.fn.float2nr(vim.fn.round(0.90 * vim.o.lines)),
    width = vim.fn.float2nr(vim.fn.round(0.90 * vim.o.columns))
})

require('neogit').setup()

require('mini.statusline').setup()

require('neoscroll').setup({ 
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'} ,
    duration_multiplier = 0.6, 
})

require("ibl").setup({
    indent = { highlight = { "LineNr" }, char = "│" }, 
    scope  = { enabled = false }
})

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "go" },
    highlight = { enable = true }
}

require('kanagawa').setup({
    undercurl = false,
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    transparent = true
})

require("telescope").setup({
    defaults = {
        preview = true,
        sorting_strategy = "ascending",
        path_displays = "smart",
        layout_strategy = "horizontal",
        file_ignore_patterns = { 
            "^.git/",  -- Ignore .git directory
            ".cache/",
        },
	mappings = {
		i = {
			['<esc>'] = require('telescope.actions').close,
            ["<C-c>"] = require("telescope.actions").delete_buffer,
		}
	},
        -- Make sure hidden files are shown
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden"
        },
    },
    pickers = {
        find_files = {
            hidden = true,
        },
    },
})

local cmp = require("cmp")
cmp.setup({
    completion = {
        autocomplete = false,   -- important: <Tab> will manually trigger popup
    },
    mapping = {
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end,
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        {
            name = "buffer",
            option = {
                get_bufnrs = function()
                    return { vim.api.nvim_get_current_buf() }
                end
            }
        },
    },
})
