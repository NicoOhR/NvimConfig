return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			-- Everything prettier's own parser list covers, minus markdown --
			-- that goes through mdformat below so the wrap width stays put.
			local formatters_by_ft = {}
			for _, ft in ipairs({
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"css",
				"scss",
				"less",
				"html",
				"json",
				"jsonc",
				"json5",
				"yaml",
				"graphql",
			}) do
				formatters_by_ft[ft] = { "prettierd", "prettier", stop_after_first = true }
			end

			require("conform").setup({
				async = false,
				formatters_by_ft = vim.tbl_extend("force", formatters_by_ft, {
					ocaml = { "ocamlformat" },
					lua = { "stylua" },
					python = { "ruff_organize_imports", "ruff_format" },
					rust = { "rustfmt", lsp_format = "fallback" },
					go = { "crlfmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					markdown = { "injected", "mdformat" },
					quarto = { "injected" },
					haskell = { "fourmolu" },
					tex = { "tex-fmt" },
					proto = { "buf" },
					verilog = { "verible" },
					systemverilog = { "verible" },
				}),
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
			-- Must match textwidth in after/ftplugin/markdown.lua, otherwise
			-- format-on-save re-wraps to a different column than you typed to.
			require("conform").formatters.mdformat = {
				args = { "--wrap", "80", "-" },
			}
		end,
	},
}
