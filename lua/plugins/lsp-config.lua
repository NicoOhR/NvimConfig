return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- Global LSP behaviour
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function()
							require("conform").format({ async = false, id = args.data.client_id })
						end,
					})

					if client and client.name ~= "hls" and client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
				end,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gt", vim.lsp.buf.definition, {})
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = false,
				update_in_insert = false,
				severity_sort = true,
				float = false,
			})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.lsp.enable("hls")
			vim.lsp.config("hls", {
				capabilities = capabilities,
				settings = {
					haskell = {
						checkParents = "CheckOnSave",
						plugin = {
							["explicit-fields"] = {
								globalOn = false,
							},
							importLens = { globalOn = false },
							inlayHints = { globalOn = false },
						},
					},
				},
			})
		end,
	},
}
