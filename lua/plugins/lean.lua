-- lean.nvim now reads its config from vim.g.lean_config; opts/setup() is deprecated
vim.g.lean_config = {
	mappings = true,
	lsp = {}, -- empty table = use defaults, which invokes `lake serve`
	progress_bars = {
		enable = false,
	},
}

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
	},
}
