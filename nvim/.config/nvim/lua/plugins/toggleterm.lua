local present, toggleterm = pcall(require, "toggleterm")
if not present then
    return
end

toggleterm.setup{
      -- size can be a number or function which is passed the current terminal
      size = 15,
      open_mapping = [[<C-j>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = true,
      direction = 'horizontal',
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
    cmd = "lazygit",
    dir = "git_dir",
    hidden = true,
    -- direction = "float",
    float_opts = {
        border = "single",
        width = 200,
        height = 50,
    },
      -- function to run on opening the terminal
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
    end,
    -- function to run on closing the terminal
    on_close = function(term)
        vim.cmd("Closing terminal")
    end,
})

function _lazygit_toggle()
    lazygit:toggle()
end
