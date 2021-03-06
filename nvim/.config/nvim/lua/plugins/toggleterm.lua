local present, toggleterm = pcall(require, "toggleterm")
if not present then
    return
end

toggleterm.setup{
      -- size can be a number or function which is passed the current terminal
      size = 90,
      open_mapping = [[<C-j>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = true,
      direction = 'vertical',
      close_on_exit = true, -- close the terminal window when the process exits
      --shell = vim.o.shell, -- change the default shell
      -- This field is only relevant if direction is set to 'float'
      float_opts = {
        -- The border key is *almost* the same as 'nvim_win_open'
        -- see :h nvim_win_open for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = 'single',
        width = 200,
        height = 50,
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        }
    }
}
-- Lazygit + toggleterm
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
    cmd = "lg",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {
        border = "curved",
        width = 200,
        height = 50,
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        }
    },
    shade_terminals = true,
    shade_filetypes = {},
    close_on_exit = true,
    -- function to run on opening the terminal
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<Cmd>close<CR>", {noremap = true, silent = true})
    end
})

function _lazygit_toggle()
    lazygit:toggle()
end

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-w>', [[<C-\><C-n><C-W>h]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()')
