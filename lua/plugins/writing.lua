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
				options = {
					"-shell-escape",
				},
			}
			vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
			vim.g.vimtex_view_method = "mupdf"
			vim.g.setlocalleader = ","
			vim.g.vimtex_quickfix_mode = 0
		end,
	},
}
