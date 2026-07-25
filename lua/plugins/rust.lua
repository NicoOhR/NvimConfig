return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				server = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					on_exit = function(code, _signal, _client_id)
						if code ~= 0 then
							vim.schedule(function()
								vim.notify("rust-analyzer exited (code " .. code .. "), restarting…", vim.log.levels.WARN)
								vim.cmd("RustAnalyzer restart")
							end)
						end
					end,
					handlers = {
						-- prevent panic backtraces from opening a blocking modal
						["window/showMessage"] = function(_, result, _ctx)
							local levels = {
								vim.log.levels.ERROR,
								vim.log.levels.WARN,
								vim.log.levels.INFO,
								vim.log.levels.DEBUG,
							}
							vim.notify(result.message, levels[result.type] or vim.log.levels.INFO)
						end,
					},
					settings = {
						["rust-analyzer"] = {
							checkOnSave = true,
							check = { command = "clippy" },
							procMacro = { enable = true },
							cachePriming = { numThreads = 2 },
							workspace = { symbol = { search = { limit = 512 } } },
						},
					},
				},
			}
		end,
	},
}
