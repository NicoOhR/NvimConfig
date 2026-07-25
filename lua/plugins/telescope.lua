return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					preview = {
					},
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-f>", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader><leader>", function()
				builtin.buffers({ initial_mode = "normal" })
			end, {})
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
			vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {})
			-- call hierarchy / tracing: who calls this, what does this call, all trait impls
			-- for a full tree-style call hierarchy UI, see aerial.nvim
			vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, {})
			vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, {})
			vim.keymap.set("n", "<leader>fm", builtin.lsp_implementations, {})

			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("fzf")
		end,
	},
}
