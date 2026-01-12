---------------------------------------------------------------------------------
-- [[ OPTIONS ]]
---------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
opt.mouse = 'a'
opt.nu = true
opt.relativenumber = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 20
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.updatetime = 50
opt.showmode = false
opt.splitright = true
opt.splitbelow = true
opt.completeopt = 'menuone,noselect'
vim.opt.isfname:append("@-@")

-- Global bridge for UI/Formatting
vim.o.breakindent = true
vim.o.winborder = 'rounded'

-- Abbreviation for quitting
vim.cmd([[ cnoreabbrev <expr> qq (getcmdtype() ==# ':' && getcmdline() ==# 'qq') ? 'q!' : 'qq' ]])

---------------------------------------------------------------------------------
-- [[ PLUGINS ]]
---------------------------------------------------------------------------------
-- Using built-in pack management
vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/akinsho/toggleterm.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/karb94/neoscroll.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/lmburns/lf.nvim" },
    { src = "https://github.com/aserowy/tmux.nvim" },
    -- UI and Colors
    { src = "https://github.com/vague-theme/vague.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    -- Snippets code completion
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/saghen/blink.cmp" },
})

---------------------------------------------------------------------------------
-- [[ PLUGIN CONFIGURATIONS ]]
---------------------------------------------------------------------------------

-- Colorscheme
require("vague").setup({ transparent = true, bold = true, italic = false })
vim.cmd("colorscheme vague")

-- UI & Navigation
require('neoscroll').setup({
    mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>' },
    duration_multiplier = 0.6,
})
require("ibl").setup({
    indent = { highlight = { "LineNr" }, char = "│" },
    scope = { enabled = false }
})
require('lf').setup({
    winblend = 0,
    height = vim.fn.float2nr(vim.fn.round(0.95 * vim.o.lines)),
    width = vim.fn.float2nr(vim.fn.round(0.95 * vim.o.columns))
})

-- Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "go" },
    highlight = { enable = true }
}

-- Completion (Blink)
require('blink.cmp').setup({
    fuzzy = { implementation = "lua" },
    completion = { menu = { auto_show = false } },
    signature = { enabled = true, trigger = { enabled = false }, window = { show_documentation = false } },
    keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    }
})

-- Telescope
require("telescope").setup({
    defaults = {
        preview = true,
        sorting_strategy = "ascending",
        path_displays = { "smart" },
        layout_strategy = "horizontal",
        file_ignore_patterns = { "^.git/", ".git/", ".cache/", "elpa/" },
        mappings = {
            i = {
                ['<esc>'] = require('telescope.actions').close,
                ["<C-c>"] = require("telescope.actions").delete_buffer,
            }
        },
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden"
        },
    },
    pickers = { find_files = { hidden = true } },
})

---------------------------------------------------------------------------------
-- [[ KEYMAPS ]]
---------------------------------------------------------------------------------
local key = vim.keymap.set

-- General
key("i", "<C-c>", "<Esc>")
key("i", "jj", "<Esc>")
key("n", "<leader>h", ":noh<CR>", { desc = "Clear highlights" })
key('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
key('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
key('n', 'L', function() vim.api.nvim_feedkeys(':', 'n', true) end)

-- Buffer & Window Management
key("n", "<leader>p", "<cmd>b#<CR>", { desc = "Previous accessed buffer" })
key("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
key("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
key("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
key("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Visual Mode
key("v", "<S-Tab>", "<gv")
key("v", "<Tab>", ">gv")
key("v", "J", ":m '>+1<CR>gv=gv")
key("v", "K", ":m '<-2<CR>gv=gv")

-- Telescope Keymaps
local builtin = require('telescope.builtin')
key('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
key('n', '<leader>e', "<CMD>Lf<CR>", { desc = 'LF file explorer' })
key('n', '<leader>r', builtin.oldfiles, { desc = 'Recent files' })
key('n', '<leader>o', builtin.buffers, { desc = 'Open buffers' })
key('n', '<leader>ss', builtin.live_grep, { desc = 'Live grep' })
key('n', '<leader>sb', builtin.current_buffer_fuzzy_find, { desc = 'Search buffer' })

-- LSP
key('n', 'K', vim.lsp.buf.hover, { desc = 'Show documentation hover' })
key('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
key('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
key('n', 'gr', vim.lsp.buf.references, { desc = 'Get references' })
key('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Get signature help' })

-- Leader-based LSP commands
key('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code actions' })
key('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Rename symbol' })
key('n', '<leader>lf', vim.lsp.buf.format, { desc = 'Format code' })
key('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Diagnostic hover' })
key('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Local list' })

-- Diagnostic navigation
key('n', '[d', vim.diagnostic.goto_prev, { desc = 'Diagnostic Previous' })
key('n', ']d', vim.diagnostic.goto_next, { desc = 'Diagnostic Next' })
key('n', '[e', function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end, { desc = 'Previous Error' })
key('n', ']e', function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end, { desc = 'Next Error' })

---------------------------------------------------------------------------------
-- [[ TERMINAL ]]
---------------------------------------------------------------------------------
key("t", "<esc><esc>", "<c-\\><c-n>")
key("t", "<C-h>", "<C-\\><C-n><C-w>h")
key("t", "<C-l>", "<C-\\><C-n><C-w>l")

key("n", "<leader>tl", function()
    vim.cmd.vnew()
    vim.api.nvim_win_set_width(0, math.floor(vim.o.columns * 0.35))
    vim.wo.winfixwidth = true
    vim.cmd.term()
end, { desc = "Terminal Vertical" })

key("n", "<leader>tj", function()
    vim.cmd.new()
    vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.35))
    vim.wo.winfixheight = true
    vim.cmd.term()
end, { desc = "Terminal Horizontal" })

---------------------------------------------------------------------------------
-- [[ LSP CONFIGURATION ]]
---------------------------------------------------------------------------------
vim.diagnostic.config {
    virtual_text = false,
    float = { border = 'rounded', focusable = true },
}

vim.lsp.config.gopls = {
    cmd = { '/home/jason/.go/bin/gopls' },
    root_markers = { 'go.mod', '.git' },
    filetypes = { 'go' },
}
vim.lsp.config.clangd = {
    cmd = { 'clangd', '--compile-commands-dir=.' },
    root_markers = { 'compile_commands.json', '.git' },
    filetypes = { 'c', 'cpp' },
}

vim.lsp.enable({'gopls', 'clangd'})

---------------------------------------------------------------------------------
-- [[ AUTOCMDS ]]
---------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', {
    group = augroup('YankHighlight', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

-- Terminal behavior
local term_group = augroup("custom-term", { clear = true })
autocmd("TermOpen", {
    group = term_group,
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.cmd("startinsert")
    end,
})
