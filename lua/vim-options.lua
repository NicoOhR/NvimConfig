vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false
local t_opts = { silent = true }
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
vim.keymap.set("t", "<esc>", "<C-\\><C-N>", t_opts)
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.opt.relativenumber = true
vim.wo.number = true
vim.opt.shell = "/usr/bin/fish"
vim.keymap.set("n", "<C-t>", function()
	require("menu").open("default")
end, {})


vim.o.updatetime = 100

-- thank you @Jesse-Bakker
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
	local default_diagnostic_handler = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, result, context, config)
		if err ~= nil and err.code == -32802 then
			return
		end
		return default_diagnostic_handler(err, result, context, config)
	end
end
