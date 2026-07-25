return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { max_lines = 3 },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({})

			-- base parser set; anything else is installed on demand below
			ts.install({
				"python",
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"bash",
				"markdown",
				"markdown_inline",
				"latex",
				"bibtex",
				"json",
				"yaml",
				"toml",
			})

			local no_highlight = { fortran = true }
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
				callback = function(args)
					local ft = args.match
					-- only real file buffers; skip dashboards, terminals, prompts, etc.
					if no_highlight[ft] or vim.bo[args.buf].buftype ~= "" then
						return
					end
					local lang = vim.treesitter.language.get_lang(ft) or ft
					local function start()
						if pcall(vim.treesitter.start, args.buf, lang) then
							vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						end
					end
					if vim.treesitter.language.add(lang) then
						start()
					elseif vim.tbl_contains(ts.get_available(), lang) then
						-- parser missing: install it in the background, then start
						ts.install({ lang }):await(function(err)
							if not err and vim.api.nvim_buf_is_valid(args.buf) then
								start()
							end
						end)
					end
				end,
			})
		end,
	},
}
