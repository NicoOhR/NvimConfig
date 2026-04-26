return {
	{
		"Julian/lean.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
			-- optional dependencies:
			-- 'nvim-telescope/telescope.nvim', -- for Lean-specific pickers
			-- 'andymass/vim-matchup',          -- for enhanced % motion behavior
			-- 'andrewradev/switch.vim',        -- for switch support
			-- 'tomtom/tcomment_vim',           -- for commenting
		},

		---@type lean.Config
		opts = {
			mappings = true,
			lsp = {}, -- empty table = use defaults, which invokes `lake serve`
			progress_bars = {
				enable = false,
			},
		},
	},
}
