---------------------------------------------------------------------------------
-- [[ PLUGINS ]]
---------------------------------------------------------------------------------
vim.pack.add({
    {src = "https://github.com/nvim-lua/plenary.nvim"},
    {src = "https://github.com/akinsho/toggleterm.nvim"},
    -- Pickers and tooling
    {src = "https://github.com/nvim-telescope/telescope.nvim"},
    {src = "https://github.com/NeogitOrg/neogit"},
    {src = "https://github.com/sindrets/diffview.nvim"},
    {src = "https://github.com/karb94/neoscroll.nvim"},
    {src = "https://github.com/folke/which-key.nvim"},
    {src = "https://github.com/lmburns/lf.nvim"},
    -- UI additions
    {src = "https://github.com/vague-theme/vague.nvim"},
    {src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master"},
    {src = "https://github.com/lukas-reineke/indent-blankline.nvim"},
    {src = "https://github.com/echasnovski/mini.statusline"},
    -- Auto complete, snippets
    {src = "https://github.com/rafamadriz/friendly-snippets"},
    {src = "https://github.com/L3MON4D3/LuaSnip" },
    {src = "https://github.com/saghen/blink.cmp"},
})

require('neogit').setup()

require('mini.statusline').setup()

require('blink.cmp').setup({ fuzzy = { implementation = "lua" } })

require('neoscroll').setup({ 
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'} ,
    duration_multiplier = 0.6, 
})

require("ibl").setup({
    indent = { highlight = { "LineNr" }, char = "│" }, 
    scope  = { enabled = false }
})

require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "go" },
    highlight = { enable = true }
}

require('lf').setup({
    winblend = 0,
    height = vim.fn.float2nr(vim.fn.round(0.95 * vim.o.lines)),
    width = vim.fn.float2nr(vim.fn.round(0.95 * vim.o.columns))
})

require("vague").setup({
    transparent = true, 
    bold = true,
    italic = false
})

require("telescope").setup({
    defaults = {
        preview = true,
        sorting_strategy = "ascending",
        path_displays = "smart",
        layout_strategy = "horizontal",
        file_ignore_patterns = { 
            "^.git/",  -- Ignore .git directory
            ".git/",  -- Ignore .git directory
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

