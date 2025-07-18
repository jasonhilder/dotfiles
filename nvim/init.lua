--------------------------------------------------------------------------------
-- [[ AUTOCMDS ]]
---------------------------------------------------------------------------------
-- Highlight on Yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
    pattern = '*',
})
---------------------------------------------------------------------------------
-- [[ OPTIONS ]]
---------------------------------------------------------------------------------
vim.g.loaded_netrw = 1                 -- Disables the default Netrw file browser
vim.g.loaded_netrwPlugin = 1           -- Disables the Netrw plugin
vim.opt.mouse = 'a'                    -- Enables mouse support in all modes
vim.opt.nu = true                      -- Enables line numbers
vim.opt.relativenumber = true          -- Displays relative line numbers in the buffer
vim.opt.tabstop = 4                    -- Sets the number of spaces that a tab character represents
vim.opt.softtabstop = 4                -- Sets the number of spaces per tab in the editor's buffer
vim.opt.shiftwidth = 4                 -- Sets the width for autoindents
vim.opt.expandtab = true               -- Converts tabs to spaces
vim.opt.smartindent = true             -- Enables intelligent autoindenting for new lines
vim.opt.wrap = false                   -- Disables text wrapping
vim.opt.swapfile = false               -- Disables swap file creation
vim.opt.backup = false                 -- Disables making a backup before overwriting a file
vim.opt.ignorecase = true              -- Makes searches case insensitive
vim.opt.smartcase = true               -- Makes searches case sensitive if there's a capital letter
vim.opt.hlsearch = true                -- Highlights all matches of the search pattern
vim.opt.incsearch = true               -- Starts searching before typing is finished
vim.opt.termguicolors = true           -- Enables true color support
vim.opt.scrolloff = 20                 -- Keeps 8 lines visible above/below the cursor
vim.opt.signcolumn = "yes"             -- Always show the sign column
vim.opt.isfname:append("@-@")          -- Allows '@' in filenames
vim.opt.clipboard = "unnamedplus"      -- Uses the system clipboard for all yank, delete, change and put operations
vim.opt.undofile = true                -- Enables persistent undo
vim.opt.updatetime = 50                -- Sets the time after which the swap file is written (in milliseconds)
vim.o.breakindent = true               -- Makes wrapped lines visually indented
vim.o.termguicolors = true             -- Enables true color support (duplicated setting)
vim.o.splitright = true                -- Set horizontal splits to the right as default
vim.o.splitbelow = true                -- Set vertical splits to the bottom as default 
vim.o.completeopt = 'menuone,noselect' -- Configures how the completion menu works
---------------------------------------------------------------------------------
-- [[ KEYMAPS ]]
---------------------------------------------------------------------------------
vim.g.mapleader = " ";
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")
-- clear search highlights
vim.keymap.set("n", "<leader>h", ":noh<CR>", { desc = "Clear highlights" })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Buffer management
vim.keymap.set("n", "<leader>p", "<cmd>b#<CR>", { desc = "Last edited buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })
-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
-- Stay in indent mode
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "unindent line" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "indent line" })
-- Move selection and format
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection up" })
-- Diagnostics
vim.keymap.set("n", "<leader>k", ":lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostic Float" })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })

---------------------------------------------------------------------------------
-- [[ TERMINAL ]]
---------------------------------------------------------------------------------
local set = vim.opt_local

-- Autocmd group for terminal behavior
local term_group = vim.api.nvim_create_augroup("custom-term", { clear = true })

-- When a terminal is opened
vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.o.scrolloff = 0
    vim.cmd("startinsert")
  end,
})

-- When re-entering a terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = term_group,
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

vim.keymap.set("n", "<leader>tl", function()
    vim.cmd.vnew()  -- Open a vertical split
    local width = math.floor(vim.o.columns * 0.35)  
    vim.api.nvim_win_set_width(0, width)
    vim.wo.winfixwidth = true
    vim.cmd.term()
    vim.cmd.startinsert()  -- Enter insert mode
end)

vim.keymap.set("n", "<leader>tj", function()
    vim.cmd.new()  -- Open a horizontal split
    local height = math.floor(vim.o.lines * 0.35)
    vim.api.nvim_win_set_height(0, height)
    vim.wo.winfixheight = true
    vim.cmd.term()
    vim.cmd.startinsert()  -- Enter insert mode
end)
---------------------------------------------------------------------------------
-- [[ CONFIGS ]]
---------------------------------------------------------------------------------
require("plugins")
require("lsp_config")
