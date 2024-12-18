return {
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
				ensure_installed = { "html", "hls", "gopls", "lua_ls", "pyright", "ocamllsp", "rust_analyzer", "tsserver", "clangd", "bufls" },
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
					-- 2
					vim.api.nvim_create_autocmd("BufWritePre", {
						-- 3
						buffer = args.buf,
						callback = function()
							-- 4 + 5
							require("conform").format({ async = false, id = args.data.client_id })
						end,
					})
				end,
			})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local noice = require("noice.lsp")
			lspconfig.gopls.setup({
				capabilities = capabilities,
				filetypes = { "go" },
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.hls.setup({
				capabilities = capabilities,
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
				filetypes = { "c", "cpp" },
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.tsserver.setup({
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
			lspconfig.bufls.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = true
				end,
				cmd = { "bufls", "serve" },
				filetypes = { "proto" },
			})
			vim.lsp.inlay_hint.enable(true, { 0 })
			vim.keymap.set("n", "K", require("noice.lsp").hover, {})
			vim.keymap.set("n", "gt", vim.lsp.buf.definition, {})
			vim.diagnostic.config({
				virtual_text = false, -- Disable virtual text
				signs = true,         -- Keep the signs (squiggly lines)
				underline = true,     -- Keep underlines for diagnostics
				update_in_insert = false, -- Do not show diagnostics while in insert mode
				severity_sort = true, -- Sort diagnostics by severity
				float = {
					border = "rounded",
				},
			})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
