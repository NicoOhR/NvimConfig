require("texpresso").attach()
vim.g.vimtex_compiler_latexmk = {
	options = {
		"-shell-escape",
		"-pdf",
		"-interaction=nonstopmode",
		"-synctex=1"
	}
}
