---------------------------------------------------------------------------------
-- Vim settings
---------------------------------------------------------------------------------
vim.o.winborder = 'rounded'

vim.diagnostic.config {
    virtual_text = false,
    float = {
        header = false,
        border = 'rounded',
        focusable = true,
    },
}
---------------------------------------------------------------------------------
-- Language servers
---------------------------------------------------------------------------------
vim.diagnostic.config {
    virtual_text = false,
    float = {
        header = false,
        border = 'rounded',
        focusable = true,
    },
}
---------------------------------------------------------------------------------
-- Language servers
---------------------------------------------------------------------------------
vim.o.winborder = 'rounded'

>>>>>>> 736c9fe (Latest updates.)
vim.lsp.config.clangd = {
  cmd = { 
      '/home/jason/.local/share/nvim/mason/bin/clangd', 
      '--background-index' 
  },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
}

vim.lsp.config.gopls = {
  cmd = { '/home/jason/.local/share/nvim/mason/bin/gopls', },
  root_markers = { 'go.mod' },
  filetypes = { 'go' },
}

vim.lsp.enable({'clangd', 'gopls'})

---------------------------------------------------------------------------------
-- Language server Keybinds
---------------------------------------------------------------------------------
-- if there is a language server active
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', 'cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        -- Map Ctrl-Space to trigger omni-completion in Insert mode
        vim.api.nvim_set_keymap('i', '<C-Space>', '<C-X><C-O>', { noremap = true, silent = true })
    end,
})

---------------------------------------------------------------------------------
-- Auto complete nvim-cmp
---------------------------------------------------------------------------------
local cmp = require('cmp')

cmp.setup({
    sources = cmp.config.sources(
        -- Use nvim_lsp if LSP is active
        {{ name = 'nvim_lsp' }}, 
        -- Only include buffer source if no LSP is active
        {{ name = 'buffer' }}
    ),
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})
