require("paq")({
	"savq/paq-nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "mikavilpas/yazi.nvim",
    "kdheepak/lazygit.nvim",
    "nvim-treesitter/nvim-treesitter",
    "lukas-reineke/indent-blankline.nvim",
    "nvim-mini/mini.statusline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "l3mon4d3/luasnip",
    "saadparwaiz1/cmp_luasnip",
    "vague2k/vague.nvim"
})

require('mini.statusline').setup()

require("ibl").setup({
    indent = { highlight = { "LineNr" }, char = "│" }, 
    scope  = { enabled = false }
})

require("vague").setup({ 
    style = { comments = "none", strings = "none", }
}) 

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "go" },
    highlight = { enable = true }
}

require("telescope").setup({
    defaults = {
        preview = true,
        sorting_strategy = "ascending",
        borderchars = { "", "", "", "", "", "", "", "" },
        path_displays = "smart",
        layout_strategy = "horizontal",
        layout_config = {
            height = 100,
            width = 400,
            prompt_position = "top",
            preview_cutoff = 0,
        },
        file_ignore_patterns = { 
            "^.git/",  -- Ignore .git directory
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
            "--hidden",  -- Add this flag
        },
    },
    pickers = {
        find_files = {
            hidden = true,  -- Show hidden files in find_files
        },
    },
})

local cmp = require("cmp")
cmp.setup({
    completion = {
        autocomplete = false 
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = {{ name = "nvim_lsp" }, { name = "luasnip" }}
})

