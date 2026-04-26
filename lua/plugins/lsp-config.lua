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
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					-- register formatting on save when LSP gets attached
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function()
							require("conform").format({ async = false, id = args.data.client_id })
						end,
					})
					--enable hints on attach unless HLS
					if client and client.name ~= "hls" and client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
				end,
			})

			-- vim.keymap.set("n", "K", require("hover").open(), {})
			vim.keymap.set("n", "gt", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = false,
			})

			-- automatically configure and enable all installed LSPs
			-- leanls is excluded because lean.nvim manages its own LSP client
			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function(args)
					for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, name = "basedpyright" })) do
						vim.diagnostic.reset(vim.lsp.diagnostic.get_namespace(client.id), args.buf)
					end
				end,
			})

			local lean_managed = { leanls = true }
			local installed_lsp = require("mason-lspconfig").get_installed_servers()
			for _, lsp in ipairs(installed_lsp) do
				if not lean_managed[lsp] then
					vim.lsp.enable(lsp)
					vim.lsp.config(lsp, {
						capabilities = capabilities,
					})
				end
			end
			-- server specific configurations can be added outside of the loop
			vim.lsp.config("basedpyright", {
				capabilities = capabilities,
				settings = {
					python = {
						pythonPath = vim.fn.exepath("python3"),
					},
					basedpyright = {
						typeCheckingMode = "basic",
						analysis = {
							diagnosticMode = "openFilesOnly",
							exclude = { "**/node_modules", "**/__pycache__", "**/tests", ".git", ".venv" },
							ignore = { "**/node_modules", "**/__pycache__", ".venv" },
						},
					},
				},
			})
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
