--vim.g.gruvbox_flat_style = "hard"
vim.g.vscode_style = "dark"
vim.g.vscode_disable_nvimtree_bg = true
vim.cmd([[
    colorscheme vscode
    syntax on
    filetype on
    filetype plugin indent on
    highlight GitSignsAddLn guibg=0x1E1E28
    highlight GitSignsAddLn guifg=#b8bb26
    highlight GitSignsChange guifg=#8ec07c
    highlight GitSignsDelete guifg=#cc241d
    highlight Normal ctermbg=NONE guibg=NONE
]])
