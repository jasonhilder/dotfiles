---------------------------------------------------------------------------------
-- Options
---------------------------------------------------------------------------------
vim.opt.colorcolumn = '90'
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
------------------------------------------------------------------------------
-- Keymaps
------------------------------------------------------------------------------
-- Spectre Searching
vim.keymap.set(
    'n',
    '<leader>S', '<cmd>lua require("spectre").open()<CR>',
    { desc = "Open Spectre" }
)
vim.keymap.set(
    'v',
    '<leader>sw',
    '<esc><cmd>lua require("spectre").open_visual()<CR>',
    { desc = "Search current word" }
)
vim.keymap.set(
    'n',
    '<leader>sf',
    '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
    { desc = "Search on current file" }
)
vim.keymap.set('n',
    '<leader>sw',
    '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
    { desc = "Search current word" }
)
-- Harpoon
vim.keymap.set(
    "n",
    "<leader><leader>",
    ":lua require('harpoon.ui').toggle_quick_menu() <CR>",
    { desc = "Harpoon List" }
)
vim.keymap.set("n",
    "<leader>ha",
    ":lua require('harpoon.mark').add_file() <CR>",
    { desc = "Harpoon add file" }
)
vim.keymap.set(
    "n",
    "<leader>hh",
    ":lua require('harpoon.ui').nav_prev() <CR>",
    { desc = "Harpoon previous file" }
)
vim.keymap.set(
    "n",
    "<leader>hl",
    ":lua require('harpoon.ui').nav_next() <CR>",
    { desc = "Harpoon next file" }
)
vim.keymap.set(
    "n",
    "<leader>b",
    ":Telescope buffers <CR>",
    { desc = "Harpoon next file" }
)
vim.keymap.set(
    "n",
    "<C-p>",
    "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
    { desc = "Find all"}
)
vim.keymap.set("n", "<C-b>", ":Telescope buffers<CR>", { silent = true })
-- Stay in indent mode
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "unindent line" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "indent line" })
-- Move selection and format
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection up" })
-- buffers
vim.keymap.set("n", "<leader>;", "<cmd>b#<CR>", { desc = "last edited buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "close buffer" })
-- Terminal mode
vim.keymap.set('t', '<C-w>h', "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set('t', '<C-w>j', "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set('t', '<C-w>k', "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set('t', '<C-w>l', "<C-\\><C-n><C-w>l", { silent = true })
------------------------------------------------------------------------------
-- AUTOCMDS
------------------------------------------------------------------------------
-- Highlight on Yank
local highlight_group = vim.api.nvim_create_augroup(
  'YankHighlight',
  { clear = true }
)
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
-- Clear white space on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})
-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
    command = "set cursorline",
    group = cursorGrp,
})
vim.api.nvim_create_autocmd(
    { "InsertEnter", "WinLeave" },
    { pattern = "*", command = "set nocursorline", group = cursorGrp }
)