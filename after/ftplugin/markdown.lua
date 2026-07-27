-- Hard-wrapped prose editing. Replaces vim-pencil (unmaintained since 2019).
--
-- The contract: lines are physically broken at 'textwidth' in the file, and
-- paragraphs re-flow automatically as you edit them, so deleting a sentence in
-- the middle pulls the following text back up to fill the gap.
--
-- Lives in after/ftplugin because $VIMRUNTIME/ftplugin/markdown.vim loads
-- *after* ~/.config/nvim/ftplugin and would otherwise clobber formatoptions.

vim.opt_local.textwidth = 80
vim.opt_local.colorcolumn = "+1"

-- Still soft-wrap the occasional unbreakable line (long URLs, wide tables)
-- rather than scrolling sideways. Normal prose never reaches this.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

-- Two formatoptions sets, applied whole so nothing lands half-configured.
--   n = recognise list markers and indent continuations under them
--   q = gq/gw reflow on demand
--   j = drop comment leaders when joining
--   1 = don't leave a one-letter word at the end of a line
--   t = hard-wrap at textwidth while typing   } prose only
--   a = re-flow the whole paragraph on edit   }
-- Deliberately NOT set: l (would freeze existing long lines and defeat the
-- point) and w (trailing-space paragraph continuation, which collides with
-- markdown's trailing-double-space hard break).
local PROSE = "nqj1ta"
local VERBATIM = "nqj1" -- neither wrap nor re-flow: leave the text exactly as typed

-- Auto-wrap and auto-reflow are what make pencil's hard mode unpleasant:
-- applied bluntly they reformat fenced code, tables and headings into nonsense
-- (a long shell command in a fence gets snapped at column 80). So both are
-- enabled only in ordinary prose, decided from the treesitter tree.
local VERBATIM_NODES = {
	fenced_code_block = true,
	code_fence_content = true,
	indented_code_block = true,
	pipe_table = true,
	pipe_table_row = true,
	pipe_table_header = true,
	html_block = true,
	atx_heading = true,
	setext_heading = true,
	link_reference_definition = true,
	minus_metadata = true, -- YAML frontmatter
	plus_metadata = true, -- TOML frontmatter
}

local function is_prose()
	local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
	if not ok or not parser then
		return false -- no parser, no guess: don't touch the text
	end
	-- get_node() alone won't do: it reads the cached tree and returns nil when
	-- nothing has parsed the buffer yet. A no-op once the tree is valid.
	if not pcall(parser.parse, parser) then
		return false
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	-- ignore_injections keeps us in the markdown tree, where fenced_code_block
	-- and pipe_table live; descending into an injection would hide them.
	local node = parser:named_node_for_range({ row - 1, col, row - 1, col }, { ignore_injections = true })
	while node do
		if VERBATIM_NODES[node:type()] then
			return false
		end
		node = node:parent()
	end
	return true -- includes blank lines between paragraphs
end

local paused = false

local function sync_reflow()
	if paused then
		return
	end
	vim.bo.formatoptions = is_prose() and PROSE or VERBATIM
end

local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMoved" }, {
	buffer = buf,
	group = vim.api.nvim_create_augroup("MarkdownReflow" .. buf, { clear = true }),
	callback = sync_reflow,
})
sync_reflow()

-- Escape hatch for hand-aligned text the guard doesn't recognise (ASCII
-- diagrams, poetry). Pauses the autocmd rather than just clearing the flags,
-- which the next cursor move would immediately undo.
vim.keymap.set("n", "<localleader>a", function()
	paused = not paused
	if paused then
		vim.bo.formatoptions = VERBATIM
		vim.notify("markdown: auto-reflow pinned off")
	else
		sync_reflow()
		vim.notify("markdown: auto-reflow back on")
	end
end, { buffer = true, desc = "Toggle markdown auto-reflow" })

vim.keymap.set("n", "<localleader>z", "<cmd>ZenMode<cr>", { buffer = true, desc = "Toggle zen mode" })
