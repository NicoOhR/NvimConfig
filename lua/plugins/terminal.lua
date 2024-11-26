return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-\>]], -- Keybinding to toggle the terminal
				direction = "float", -- Choose "float", "horizontal", "vertical", or "tab"
				close_on_exit = true, -- Close terminal when the process exits
				shell = vim.o.shell, -- Use your default shell
			})
		end,
	},
}
