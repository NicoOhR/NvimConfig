return {
	{ "sheerun/vim-polyglot" },
	{
		"preservim/vim-pencil",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					vim.fn["pencil#init"]({ wrap = "soft" })
					vim.opt_local.linebreak = true
					vim.opt_local.breakindent = true
					vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
					vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
				end,
			})
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = 88,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
				},
			},
		},
		config = function(_, opts)
			require("zen-mode").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					vim.opt_local.textwidth = 88
					vim.opt_local.colorcolumn = "+1"
					vim.keymap.set("n", "<localleader>z", "<cmd>ZenMode<cr>", { buffer = true, desc = "Toggle zen mode" })
				end,
			})
		end,
	},
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
