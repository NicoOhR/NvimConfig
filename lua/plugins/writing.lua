return {
	{ "sheerun/vim-polyglot" },
	{ "preservim/vim-pencil" },
	{ "folke/zen-mode.nvim" },
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "build",
			}

			vim.g.vimtex_view_method = "zathura"
			vim.g.setlocalleader = ","
		end,
	},
}
