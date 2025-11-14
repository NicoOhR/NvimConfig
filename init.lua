vim.g.maplocalleader = ","

vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.jukit_mappings_ext_enabled = { "py", "ipynb" }

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("user.commands")
require("vim-options")
require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		require("conform").format()
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.md", "*.qmd", "*.ipynb" },
	callback = function() end,
})

vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

vim.cmd.colorscheme("gruvbox")
