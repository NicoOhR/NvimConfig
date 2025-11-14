return {
	"ggandor/leap.nvim",
	config = function()
		local leap = require("leap")
		leap.opts.case_sensitive = true
		leap.opts.highlight_unlabeled_phase_one_targets = true
		vim.keymap.set({'n','x','o'}, 's','<Plug>(leap)')
	end,
}
