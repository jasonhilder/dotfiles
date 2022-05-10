vim.o.background = "dark"
vim.cmd([[
    colorscheme catppuccin
    syntax on
    filetype on
    filetype plugin indent on
    highlight GitSignsAddLn guibg=0x1E1E28
    highlight GitSignsAddLn guifg=#b8bb26
    highlight GitSignsChange guifg=#8ec07c
    highlight GitSignsDelete guifg=#cc241d
]])
