vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false
local t_opts = { silent = true }
-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set('n', '<F5>', '<cmd>call vimspector#Launch()<cr>')
vim.keymap.set('t', '<esc>', '<C-\\><C-N>', t_opts)
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

vim.keymap.set("n", "<C-t>", function()
  require("menu").open("default")
end, {})

vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(0, {
      scope = "cursor",
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
        "InsertEnter",
      },
    })
  end
})
