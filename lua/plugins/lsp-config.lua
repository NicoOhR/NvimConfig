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

			-- K once → hover.nvim popup; K again while float is open → close float and
			-- open the same content in a proper split buffer (not a float).
			local function smart_hover()
				-- Scan all windows for a visible markdown/nofile float (hover popup)
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
					if ok and cfg.relative ~= "" then
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].filetype == "markdown" and vim.bo[buf].buftype == "nofile" then
							-- Capture source window before creating the split
							local src_win = vim.api.nvim_get_current_win()
							-- Found the hover float — grab its lines, close it, open a split
							local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
							vim.api.nvim_win_close(win, true)
							vim.cmd("belowright vsplit")
							local new_buf = vim.api.nvim_create_buf(false, true)
							vim.api.nvim_win_set_buf(0, new_buf)
							vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, lines)
							vim.bo[new_buf].filetype = "markdown"
							vim.bo[new_buf].modifiable = false
							vim.bo[new_buf].buftype = "nofile"
							vim.bo[new_buf].bufhidden = "wipe"
							vim.bo[new_buf].swapfile = false
							pcall(vim.api.nvim_buf_set_name, new_buf, "LSP Docs")
							-- gt: follow file links (markdown links, file:// URIs, bare paths)
							vim.keymap.set("n", "gt", function()
								local line = vim.api.nvim_get_current_line()
								local target
								-- markdown link: [text](target) — extract the link part
								local link = line:match("%[.-%]%((.-)%)")
								if link and link ~= "" then
									-- file:// URI inside a markdown link
									if link:match("^file://") then
										target = vim.uri_to_fname(link)
									else
										target = link
									end
								end
								-- bare file:// URI on the line
								if not target or target == "" then
									local uri = line:match("file://[^%s%)]+")
									if uri then
										target = vim.uri_to_fname(uri)
									end
								end
								-- fallback: path under cursor (gf-style)
								if not target or target == "" then
									target = vim.fn.expand("<cfile>")
								end
								if target and target ~= "" then
									if vim.fn.filereadable(target) == 0 then
										vim.notify("Cannot open: " .. target, vim.log.levels.WARN)
										return
									end
									vim.api.nvim_win_close(0, true)
									if vim.api.nvim_win_is_valid(src_win) then
										vim.api.nvim_set_current_win(src_win)
									end
									vim.cmd("edit " .. vim.fn.fnameescape(target))
								else
									vim.notify("No file link found under cursor", vim.log.levels.INFO)
								end
							end, { buffer = new_buf, desc = "Follow file link in LSP Docs" })
							return
						end
					end
				end
				-- No float open — show the hover popup normally
				require("hover").open()
			end

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
					-- K: hover popup; K again while popup is open: open docs in a split buffer
					vim.keymap.set("n", "K", smart_hover, { buffer = args.buf, desc = "LSP hover / open docs in split" })
				end,
			})

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
					for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, name = "pyrefly" })) do
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
			vim.lsp.config("pyrefly", {
				capabilities = capabilities,
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
