return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				async = false,
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					go = { "crlfmtl" },
					c = { "clang-format" },
					markdown = { "injected" },
					quarto = { "injected" },
					haskell = { "fourmolu" },
					latex = { "tex-fmt" },
				},
			})
			-- Customize the "injected" formatter
			require("conform").formatters.injected = {
				-- Set the options field
				options = {
					-- Set to true to ignore errors
					ignore_errors = true,
					-- Map of treesitter language to file extension
					-- A temporary file name with this extension will be generated during formatting
					-- because some formatters care about the filename.
					lang_to_ext = {
						bash = "sh",
						c_sharp = "cs",
						elixir = "exs",
						javascript = "js",
						julia = "jl",
						latex = "tex",
						markdown = "md",
						python = "py",
						ruby = "rb",
						rust = "rs",
						teal = "tl",
						r = "r",
						typescript = "ts",
					},
					-- Map of treesitter language to formatters to use
					--
					-- (defaults to the value from formatters_by_ft)
					lang_to_formatters = {},
				},
			}
		end,
	},
}
