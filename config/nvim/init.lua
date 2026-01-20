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
vim.opt.lazyredraw = true

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
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/karb94/neoscroll.nvim" },
    { src = "https://github.com/akinsho/toggleterm.nvim" },
    { src = "https://github.com/lmburns/lf.nvim" },
    { src = "https://github.com/aserowy/tmux.nvim" },
    -- UI and Colors
    { src = "https://github.com/aktersnurra/no-clown-fiesta.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/norcalli/nvim-colorizer.lua" },
})

---------------------------------------------------------------------------------
-- [[ PLUGIN CONFIGURATIONS ]]
---------------------------------------------------------------------------------
-- tmux
require("tmux").setup({})

-- Colorscheme
require("no-clown-fiesta").setup({
    theme = "dark",
    transparent = true,
    styles = { lsp = { underline = true } }
})
-- Set installed colorscheme
vim.cmd("colorscheme no-clown-fiesta")

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
    border = "single",
    winblend = 0,
    height = vim.fn.float2nr(vim.fn.round(0.95 * vim.o.lines)),
    width = vim.fn.float2nr(vim.fn.round(0.95 * vim.o.columns))
})

-- Treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "go" },
    highlight = { enable = true }
}

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

-- Diagnostic navigation
key('n', '[d', vim.diagnostic.goto_prev, { desc = 'Diagnostic Previous' })
key('n', ']d', vim.diagnostic.goto_next, { desc = 'Diagnostic Next' })
key('n', '[e', function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end, { desc = 'Previous Error' })
key('n', ']e', function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end, { desc = 'Next Error' })

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

-- AutoComplete
autocmd("TextChangedI", {
    group = augroup("AutoComplete", { clear = true }),
    callback = function()
        -- Skip in special buffer types (telescope, terminal, etc.)
        if vim.bo.buftype ~= '' then
            return
        end
        
        if vim.fn.pumvisible() == 0 then
            local col = vim.fn.col('.')
            local line = vim.fn.getline('.')
            local before_cursor = line:sub(1, col - 1)
            
            -- Get the current word being typed
            local current_word = before_cursor:match('[%w_]+$') or ''
            
            -- Only trigger if we have 2+ characters
            if #current_word >= 2 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n')
            end
        end
    end,
})

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
---------------------------------------------------------------------------------
-- [[ QUICKFIX LIST ]]
---------------------------------------------------------------------------------
-- Set diagnostics to location list and toggle it open/closed
function ToggleQuickfixWithDiagnostics()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["loclist"] == 1 then
            qf_exists = true
        end
    end
    
    if qf_exists then
        vim.cmd("lclose")
    else
        vim.diagnostic.setloclist({open = true})
    end
end

key('n', '<leader>qq', ToggleQuickfixWithDiagnostics, {desc = "Toggle diagnostics list"})
-- Navigate location list items
key('n', '<leader>qn', function() pcall(vim.cmd, "lnext") vim.cmd("normal! zz") end, {desc = "Next diagnostic"})
key('n', '<leader>qp', function() pcall(vim.cmd, "lprev") vim.cmd("normal! zz") end, {desc = "Previous diagnostic"})
