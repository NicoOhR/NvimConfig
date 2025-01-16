return {
	{
		'mrcjkb/haskell-tools.nvim',
		version = '^4', -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "html", "cmake", "gopls", "lua_ls", "pyright", "ocamllsp", "rust_analyzer", "ts_ls", "clangd", "buf_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		setup = {},
		opts = {},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp", { clear = true }),
				callback = function(args)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function()
							require("conform").format({ async = false, id = args.data.client_id })
						end,
					})
				end,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
				filetypes = { "go" },
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
				filetypes = { "c", "cpp" },
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				filetypes = { "python" },
			})
			lspconfig.ocamllsp.setup({
				capabilities = capabilities,
				filetypes = { "ocaml" },
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})
			lspconfig.cmake.setup({
				capabilities = capabilities,
			})
			lspconfig.buf_ls.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = true
				end,
				cmd = { "bufls", "serve" },
				filetypes = { "proto" },
			})
			vim.lsp.inlay_hint.enable(true, { 0 })
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
		end,
	},
}
