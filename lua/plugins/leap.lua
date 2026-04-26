return {
	url = "https://codeberg.org/andyg/leap.nvim",
	config = function()
		local leap = require("leap")
		leap.opts.preview = true
		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
	end,
}
