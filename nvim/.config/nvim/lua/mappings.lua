local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local cmd = vim.cmd
local opt = {}

vim.g.mapleader = " "

-- remove trailing whitespaces
cmd([[autocmd BufWritePre * %s/\s\+$//e]])
cmd([[autocmd BufWritePre * %s/\n\+\%$//e]])

-- Quality of life stuff
map("n", "Y", "y$")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>k", ":m .-2<CR>==")
map("n", "<Leader>j", ":m .+1<CR>==")
map("i", "<C-J> <esc>", ":m .+1<CR>==")
map("i", "<C-K <esc>", ":m .-2<CR>==")

-- commentor maps (vim registers _ as /)
map("n", "<C-c>", ":CommentToggle<CR>", opt)
map("v", "<C-c>", ":CommentToggle<CR>", opt)

-- Telescope options
map("n", "<Leader>pp", [[<Cmd> Telescope builtin <CR>]], opt)
-- Recently used files
map("n", "<Leader>m", [[<Cmd> Telescope oldfiles <CR>]], opt)
-- Show open buffers
map("n", ";", [[<Cmd> Telescope buffers <CR>]], opt)
-- Find in current buffer
map("n", "<Leader>/", [[<Cmd> Telescope current_buffer_fuzzy_find <CR>]], opt)
-- git files
map("n", "<Leader>gf", [[<Cmd> Telescope git_files <CR>]], opt)
-- Folders files
map("n", "<Leader>ff", [[ <Cmd> Telescope file_browser <CR>]], opt)
-- All Files
map("n", "<Leader>bfs", [[<Cmd> Telescope find_files <CR>]], opt)
-- ripgrep like grep through directory
map("n", "<Leader>rg", [[<Cmd> Telescope live_grep <CR>]], opt)
-- Show file git difs in new window
map("n", "<Leader>gd", ":vert Git diff<CR>", opt)
-- Show git status with changes
map("n", "<Leader>gs", [[<Cmd> Telescope git_status <CR>]], opt)
-- Show git commits
map("n", "<Leader>gc", [[<Cmd> Telescope git_commits <CR>]], opt)
-- Help Tags
map("n", "<Leader>fh", [[<Cmd> Telescope help_tags <CR>]], opt)
-- Kill Current buffer
map("n", "<Leader>bd", ":bd!<CR>", opt)
-- Disable highlighting
map("n", "<Leader>h", ":noh<CR>", opt)

-- bufferline
map("n", "[", ":BufferLineCyclePrev<CR>", opt)
map("n", "]", ":BufferLineCycleNext<CR>", opt)

-- Nvim Tree
map("n", "<C-n>", ":NvimTreeToggle<CR>", opt)
map("n", "<leader>n", ":NvimTreeFindFile<CR>", opt)

-- LSP maps
map("n", "gD", [[<Cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
map("n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts)
map("n", "K", [[<Cmd>lua vim.lsp.buf.hover()<CR>]], opts)
map("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
map("n", "<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)
map("n", "<space>D", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
map("n", "<space>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts)
map("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]], opts)
map("n", "<space>e", [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], opts)
map("n", "[d", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
map("n", "]d", [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
map("n", "<space>q", [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], opts)

-- lazygit
map("n", "<leader>g", ":LazyGit<CR>]]", opts)
