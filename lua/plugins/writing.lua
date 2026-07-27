return {
	{
		"sheerun/vim-polyglot",
		init = function()
			-- polyglot's indent/markdown.vim forces formatoptions+=t back on after
			-- our ftplugin runs, which re-enables auto-hard-wrap while typing.
			-- Its markdown syntax is also redundant with the treesitter
			-- markdown/markdown_inline parsers we already install.
			vim.g.polyglot_disabled = { "markdown" }
		end,
	},
	-- Markdown soft-wrap + motions live in ftplugin/markdown.lua (no plugin needed).
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
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
			vim.g.vimtex_view_method = "zathura"
			vim.g.setlocalleader = ","
			vim.g.vimtex_quickfix_mode = 0
		end,
	},
}
